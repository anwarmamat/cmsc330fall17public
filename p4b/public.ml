open OUnit2
open Types
open Eval
open Utils
open TestUtils

let env1 = [("var1", Val_Int 4); ("var2", Val_Bool false)]

let test_expr_basic ctxt =
  let i = 5 in assert_equal (Val_Int i) (eval_expr [] (Int i));
  let i = (-10) in assert_equal (Val_Int i) (eval_expr [] (Int i));
  assert_equal (Val_Bool true) (eval_expr env1 (Bool true));
  assert_equal (Val_Bool false) (eval_expr env1 (Bool false));
  assert_equal (Val_Int 4) (eval_expr env1 (Id "var1"));
  assert_equal (Val_Bool false) (eval_expr env1 (Id "var2"))

let test_expr_ops ctxt =
  assert_equal (Val_Int 8) (eval_expr env1 (Plus ((Id "var1"), (Int 4))));
  assert_equal (Val_Int (-2)) (eval_expr env1 (Plus ((Id "var1"), (Int (-6)))));
  assert_equal (Val_Int 42) (eval_expr [] (Sub (Int 50, Int 8)));
  assert_equal (Val_Int (-2)) (eval_expr env1 (Sub (Id "var1", Int 6)));
  assert_equal (Val_Int 64) (eval_expr [] (Mult (Int 8, Int 8)));
  assert_equal (Val_Int (-10)) (eval_expr [] (Mult (Int 5, Int (-2))));
  assert_equal (Val_Int 10) (eval_expr [] (Div (Int 70, Int 7)));
  assert_equal (Val_Int (50/3)) (eval_expr [] (Div (Int 50, Int 3)));
  assert_equal (Val_Int 9) (eval_expr [] (Pow (Int 3, Int 2)));

  assert_equal (Val_Bool true) (eval_expr [] (Or (Bool false, Bool true)));
  assert_equal (Val_Bool false) (eval_expr env1 (Or (Bool false, Id "var2")));
  assert_equal (Val_Bool false) (eval_expr [] (And (Bool false, Bool true)));
  assert_equal (Val_Bool true) (eval_expr [] (And (Bool true, Bool true)));
  assert_equal (Val_Bool true) (eval_expr [] (Not (Bool false)));
  assert_equal (Val_Bool false) (eval_expr [] (Not (Bool true)));

  assert_equal (Val_Bool false) (eval_expr env1 (Equal (Id "var1", Int 10)));
  assert_equal (Val_Bool true) (eval_expr env1 (Equal (Id "var2", Bool false)));
  assert_equal (Val_Bool true) (eval_expr env1 (NotEqual (Id "var1", Int 10)));
  assert_equal (Val_Bool false) (eval_expr env1 (NotEqual (Id "var2", Id "var2")));

  assert_equal (Val_Bool true) (eval_expr env1 (Greater (Id "var1", Int 2)));
  assert_equal (Val_Bool false) (eval_expr env1 (Greater (Int 2, Id "var1")));
  assert_equal (Val_Bool true) (eval_expr env1 (Less (Id "var1", Int 10)));
  assert_equal (Val_Bool false) (eval_expr env1 (Less (Id "var1", Int 2)));
  assert_equal (Val_Bool true) (eval_expr [] (GreaterEqual (Int 0, Int 0)));
  assert_equal (Val_Bool false) (eval_expr [] (GreaterEqual (Int 0, Int 1)));
  assert_equal (Val_Bool false) (eval_expr [] (LessEqual (Int 1, Int 0)))

let test_expr_fail ctxt =
  assert_expr_fail expr_env "1 + p";
  assert_expr_fail expr_env "false * y";
  assert_expr_fail expr_env "q - 1";
  assert_expr_fail expr_env "y / false";
  assert_expr_fail expr_env "x ^ true";
  assert_expr_fail expr_env "1 || q";
  assert_expr_fail expr_env "p && 0";
  assert_expr_fail expr_env "!x";
  assert_expr_fail expr_env "x > p";
  assert_expr_fail expr_env "q < y";
  assert_expr_fail expr_env "q >= x";
  assert_expr_fail expr_env "x <= q";
  assert_expr_fail expr_env "p == x";
  assert_expr_fail expr_env "p != x";
  assert_expr_fail expr_env "x + (y + true)";
  assert_expr_fail expr_env "(x * false) * y";
  assert_expr_fail expr_env "x - (false - 1)";
  assert_expr_fail expr_env "y / (true / x)";
  assert_expr_fail expr_env "x ^ (false ^ y)";
  assert_expr_fail expr_env "(q || 1) || p";
  assert_expr_fail expr_env "q && (1 && q)";
  assert_expr_fail expr_env "!p && !1";
  assert_expr_fail expr_env "p == (y > false)";
  assert_expr_fail expr_env "q && (true < y)";
  assert_expr_fail expr_env "(y >= true) || q";
  assert_expr_fail expr_env "(x <= true) != q";
  assert_expr_fail expr_env "(x == false) == q";
  assert_expr_fail expr_env "(y == true) == p"

(* Simple sequence *)
let test_stmt_basic ctxt = 
  let env = [("a", Val_Bool true); ("b", Val_Int 7)] in assert_stmt_success env env "int main(){}";
  assert_stmt_success [] [("a", Val_Int 0); ("b", Val_Int 0); ("x", Val_Bool false); ("y", Val_Bool false)] "int main() {int a;int b;bool x; bool y;}";
  assert_stmt_success [] [("a", Val_Int 0)] "int main() {int a; printf(a);}"
    ~output:"0\n";
  assert_stmt_success [] [("a", Val_Bool false)] "int main() {bool a; printf(a);}"
    ~output:"false\n"

(* Simple if true and if false *)
let test_stmt_control ctxt =
  assert_stmt_success [("a", Val_Bool true)] [("a", Val_Bool true); ("b", Val_Int 5)] "int main() {int b;if(a) { b=5;} else { b=10;}}";
  assert_stmt_success [("a", Val_Bool false)] [("a", Val_Bool false); ("b", Val_Int 10)] "int main() {int b;if(a) { b=5;} else { b=10;}}"

(* Simple define int/ bool - test defaults *)
let test_define_1 = create_system_test [] [("a", Val_Int 0)] "public_inputs/define1.c"
let test_define_2 = create_system_test [] [("a", Val_Bool false)] "public_inputs/define2.c"

(* Simple assign int/bool/exp*)
let test_assign_1 = create_system_test [] [("a", Val_Int 100)] "public_inputs/assign1.c"
let test_assign_2 = create_system_test [] [("a", Val_Bool true)] "public_inputs/assign2.c"
let test_assign_exp = create_system_test [] [("a", Val_Int 0)] "public_inputs/assign-exp.c"
    ~output:"0\n"

(* equal & not equal & less *)
let test_notequal = create_system_test [] [("a", Val_Int 100)] "public_inputs/notequal.c"
    ~output:"100\n"
let test_equal = create_system_test [] [("a", Val_Int 200)] "public_inputs/equal.c" 
    ~output:"200\n"
let test_less = create_system_test [] [("a", Val_Int 200)] "public_inputs/less.c"
    ~output:"200\n"

(* Some expressions *)
let test_exp_1 = create_system_test [] [("a", Val_Int 322)] "public_inputs/exp1.c" 
    ~output:"322\n"
let test_exp_2 = create_system_test [] [("a", Val_Int 8002)] "public_inputs/exp2.c" 
    ~output:"8002\n"
let test_exp_3 = create_system_test [] [("a", Val_Int (-1))] "public_inputs/exp3.c" 
    ~output:"-1\n"

(* If/ Else/ While *)
let test_ifelse = create_system_test [] [("a", Val_Int 200)] "public_inputs/ifelse.c"
let test_if_else_while = create_system_test [] [("b", Val_Int 0);("a", Val_Int 200)] "public_inputs/if-else-while.c"
let test_while = create_system_test [] [("a", Val_Int 10); ("b", Val_Int 11)] "public_inputs/while.c" 
    ~output:"1\n3\n5\n7\n9\n"
let test_nested_ifelse = create_system_test [] [("a", Val_Int 400)] "public_inputs/nested-ifelse.c"
let test_nested_while = create_system_test [] [("sum", Val_Int 405);("j", Val_Int 10); ("i", Val_Int 10)] "public_inputs/nested-while.c"

(* NoOp *)
let test_main = create_system_test [] [] "public_inputs/main.c"

(* More Comprehensive *)
let test_test_1 = create_system_test [] [("a", Val_Int 10);("sum", Val_Int 45); ("b", Val_Int 10)] "public_inputs/test1.c"
    ~output:"1\n10\n1\n3\n10\n3\n6\n10\n6\n10\n10\n10\n15\n10\n15\n21\n10\n21\n28\n10\n28\n36\n10\n36\n45\n20\n45\n"
let test_test_2 = create_system_test [] [("a", Val_Int 10);("c", Val_Int 0); ("b", Val_Int 20)] "public_inputs/test2.c"
    ~output:"10\n"
  let test_test_3 = create_system_test [] [("a", Val_Int 10);("c", Val_Int 64); ("b", Val_Int 2)] "public_inputs/test3.c"
      ~output:"64\nfalse\n"

let test_stmt_fail_basic _ = 
  assert_stmt_fail stmt_env "printf((x + y) > false);" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "printf(!(p || q));" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "int y; int x;" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "bool q; bool p;" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "int y; bool x;" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "bool q; int p;" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "x = false;";
  assert_stmt_fail expr_env "x = y + (p && q);";
  assert_stmt_fail stmt_env "y = 1;" ~expect:DeclarationExpect;
  assert_stmt_fail expr_env "x = (y + x) > z;" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "p = 1;";
  assert_stmt_fail expr_env "q = p || (x && q);";
  assert_stmt_fail stmt_env "q = false;" ~expect:DeclarationExpect;
  assert_stmt_fail expr_env "q = q || !(p && r);" ~expect:DeclarationExpect 

let test_stmt_fail_control _ = 
  assert_stmt_fail stmt_env "if (0) {x = 0;} else {x = 1;}";
  assert_stmt_fail stmt_env "if (p || q) {x = 0;} else {x = 1;}" ~expect:DeclarationExpect;
  assert_stmt_fail expr_env "if (x / (y * 2)) {x = 0;} else {x = 1;}";
  assert_stmt_fail stmt_env "if (true) {printf(!p); p = !(p && q);} else {x = x - x;}" ~expect:DeclarationExpect;
  assert_stmt_fail expr_env "if (false) {x = y * y;} else {printf(x * (p && x)); x = 1;}";
  assert_stmt_fail stmt_env "if (false) {p = !p;} else {x = (x * x) / y; printf(x);}" ~expect:DeclarationExpect;
  assert_stmt_fail stmt_env "while (0) {x = x + 1;}";
  assert_stmt_fail stmt_env "while ((p || q) !=  false) {x = x + 1;}" ~expect:DeclarationExpect;
  assert_stmt_fail expr_env "while (x - (x + y)) {x = x + 1; printf(x * x);}";
  assert_stmt_fail expr_env "while (true) {p = p && q; printf(x + (p < q));}"

(* val eval_expr : Types.eval_environment -> Types.expr -> Types.value_type *)
let public = 
  "public" >::: [
    "expr_basic" >:: test_expr_basic;
    "expr_ops" >:: test_expr_ops;
    "expr_fail" >:: test_expr_fail;

    "stmt_basic" >:: test_stmt_basic;
    "stmt_control" >:: test_stmt_control;

    "define_1" >:: test_define_1;
    "define_2" >:: test_define_2;
    "assign_1" >:: test_assign_1;
    "assign_2" >:: test_assign_2;
    "assign_exp" >:: test_assign_exp;
    "notequal" >:: test_notequal;
    "equal" >:: test_equal;
    "less" >:: test_less;
    "exp_1" >:: test_exp_1;
    "exp_2" >:: test_exp_2;
    "exp_3" >:: test_exp_3;
    "ifelse" >:: test_ifelse;
    "if_else_while" >:: test_if_else_while;
    "while" >:: test_while;
    "nested_ifelse" >:: test_nested_ifelse;
    "nested_while" >:: test_nested_while;
    "main" >:: test_main;
    "test_1" >:: test_test_1;
    "test_2" >:: test_test_2;
    "test_3" >:: test_test_3;
    "stmt_fail_basic" >:: test_stmt_fail_basic;
    "stmt_fail_control" >:: test_stmt_fail_control
  ]

let _ = run_test_tt_main public
