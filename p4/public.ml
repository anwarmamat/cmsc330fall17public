open OUnit2
open SmallCTypes
open TestUtils

let test_assign1 = create_system_test "public_inputs/assign1.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), NoOp)))
let test_assign_exp = create_system_test "public_inputs/assign-exp.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Mult(Int 100, Id "a")), Seq(Print(Id "a"), NoOp))))
let test_define_1 = create_system_test "public_inputs/define1.c"
  (Seq(Declare(Type_Int, "a"), NoOp))
let test_equal = create_system_test "public_inputs/equal.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(If(Equal(Id "a", Int 100), Seq(Assign("a", Int 200), Seq(Print(Id "a"), NoOp)), NoOp), NoOp))))
let test_exp_1 = create_system_test "public_inputs/exp1.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Plus(Int 2, Mult(Int 5, Pow(Int 4, Int 3)))), Seq(Print(Id "a"), NoOp))))
let test_exp_2 = create_system_test "public_inputs/exp2.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Plus(Int 2, Pow(Mult(Int 5, Int 4), Int 3))), Seq(Print(Id "a"), NoOp))))
let test_greater = create_system_test "public_inputs/greater.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(Id "a", Int 10), Seq(Assign("a", Int 200), Seq(Print(Id "a"), NoOp)), NoOp), NoOp))))
let test_if = create_system_test "public_inputs/if.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(Id "a", Int 10), Seq(Assign("a", Int 200), NoOp), NoOp), NoOp))))
let test_ifelse = create_system_test "public_inputs/ifelse.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(Id "a", Int 10), Seq(Assign("a", Int 200), NoOp), Seq(Assign("a", Int 300), NoOp)), NoOp))))
let test_if_else_while = create_system_test "public_inputs/if-else-while.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(Declare(Type_Int, "b"), Seq(If(Greater(Id "a", Int 10), Seq(Assign("a", Int 200), NoOp), Seq(Assign("b", Int 10), Seq(While(Less(Mult(Id "b", Int 2), Id "a"), Seq(Assign("b", Plus(Id "b", Int 2)), Seq(Print(Id "b"), NoOp))), Seq(Assign("a", Int 300), NoOp)))), NoOp)))))
let test_less = create_system_test "public_inputs/less.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(If(Less(Id "a", Int 200), Seq(Assign("a", Int 200), Seq(Print(Id "a"), NoOp)), NoOp), NoOp))))
let test_main = create_system_test "public_inputs/main.c"
  NoOp
let test_nested_if = create_system_test "public_inputs/nested-if.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(Id "a", Int 10), Seq(Assign("a", Int 200), Seq(If(Less(Id "a", Int 20), Seq(Assign("a", Int 300), NoOp), Seq(Assign("a", Int 400), NoOp)), NoOp)), NoOp), NoOp))))
let test_nested_ifelse = create_system_test "public_inputs/nested-ifelse.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(If(Greater(Id "a", Int 10), Seq(Assign("a", Int 200), Seq(If(Less(Id "a", Int 20), Seq(Assign("a", Int 300), NoOp), Seq(Assign("a", Int 400), NoOp)), NoOp)), Seq(Assign("a", Int 500), NoOp)), NoOp))))
let test_nested_while = create_system_test "public_inputs/nested-while.c"
  (Seq(Declare(Type_Int, "i"), Seq(Declare(Type_Int, "j"), Seq(Assign("i", Int 1), Seq(Declare(Type_Int, "sum"), Seq(Assign("sum", Int 0), Seq(While(Less(Id "i", Int 10), Seq(Assign("j", Int 1), Seq(While(Less(Id "j", Int 10), Seq(Assign("sum", Plus(Id "sum", Id "j")), Seq(Assign("j", Plus(Id "j", Int 1)), NoOp))), Seq(Assign("i", Plus(Id "i", Int 1)), NoOp)))), NoOp)))))))
let test_print = create_system_test "public_inputs/print.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 100), Seq(Print(Id "a"), NoOp))))
let test_test1 = create_system_test "public_inputs/test1.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 10), Seq(Declare(Type_Int, "b"), Seq(Assign("b", Int 1), Seq(Declare(Type_Int, "sum"), Seq(Assign("sum", Int 0), Seq(While(Less(Id "b", Id "a"), Seq(Assign("sum", Plus(Id "sum", Id "b")), Seq(Assign("b", Plus(Id "b", Int 1)), Seq(Print(Id "sum"), Seq(If(Greater(Id "a", Id "b"), Seq(Print(Int 10), NoOp), Seq(Print(Int 20), NoOp)), Seq(Print(Id "sum"), NoOp)))))), NoOp))))))))
let test_test2 = create_system_test "public_inputs/test2.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 10), Seq(Declare(Type_Int, "b"), Seq(Assign("b", Int 20), Seq(Declare(Type_Int, "c"), Seq(If(Less(Id "a", Id "b"), Seq(If(Less(Pow(Id "a", Int 2), Pow(Id "b", Int 3)), Seq(Print(Id "a"), NoOp), Seq(Print(Id "b"), NoOp)), NoOp), Seq(Assign("c", Int 1), Seq(While(Less(Id "c", Id "a"), Seq(Print(Id "c"), Seq(Assign("c", Plus(Id "c", Int 1)), NoOp))), NoOp))), NoOp)))))))
let test_test3 = create_system_test "public_inputs/test3.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 10), Seq(Declare(Type_Int, "b"), Seq(Assign("b", Int 2), Seq(Declare(Type_Int, "c"), Seq(Assign("c", Plus(Id "a", Mult(Id "b", Pow(Int 3, Int 3)))), Seq(Print(Equal(Id "c", Int 1)), NoOp))))))))
let test_test4 = create_system_test "public_inputs/test4.c"
  (Seq(Declare(Type_Int, "x"), Seq(Declare(Type_Int, "y"), Seq(Declare(Type_Int, "a"), Seq(While(Equal(Id "x", Id "y"), Seq(Assign("a", Int 100), NoOp)), Seq(If(Equal(Id "a", Id "b"), Seq(Print(Int 20), NoOp), Seq(Print(Int 10), NoOp)), NoOp))))))
let test_test_assoc1 = create_system_test "public_inputs/test-assoc1.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Plus(Int 2, Plus(Int 3, Int 4))), Seq(Declare(Type_Int, "b"), Seq(Assign("b", Mult(Int 2, Mult(Int 3, Int 4))), Seq(Declare(Type_Int, "c"), Seq(Assign("c", Pow(Int 2, Pow(Int 3, Int 4))), Seq(Declare(Type_Int, "d"), Seq(If(Greater(Int 5, Greater(Int 6, Int 1)), Seq(Print(Int 10), NoOp), NoOp), Seq(Print(Id "a"), Seq(Print(Id "b"), Seq(Print(Id "c"), NoOp))))))))))))
let test_while = create_system_test "public_inputs/while.c"
  (Seq(Declare(Type_Int, "a"), Seq(Assign("a", Int 10), Seq(Declare(Type_Int, "b"), Seq(Assign("b", Int 1), Seq(While(Less(Id "b", Id "a"), Seq(Print(Id "b"), Seq(Assign("b", Plus(Id "b", Int 2)), NoOp))), NoOp))))))

let suite =
  "public" >::: [
    "assign1" >:: test_assign1;
    "assign-exp" >:: test_assign_exp;
    "define1" >:: test_define_1;
    "equal" >:: test_equal;
    "exp1" >:: test_exp_1;
    "exp2" >:: test_exp_2;
    "greater" >:: test_greater;
    "if" >:: test_if;
    "ifelse" >:: test_ifelse;
    "if-else-while" >:: test_if_else_while;
    "less" >:: test_less;
    "main" >:: test_main;
    "nested-if" >:: test_nested_if;
    "nested-ifelse" >:: test_nested_ifelse;
    "nested-while" >:: test_nested_while;
    "print" >:: test_print;
    "test1" >:: test_test1;
    "test2" >:: test_test2;
    "test3" >:: test_test3;
    "test4" >:: test_test4;
    "test-assoc1" >:: test_test_assoc1;
    "while" >:: test_while;
  ]

let _ = run_test_tt_main suite
