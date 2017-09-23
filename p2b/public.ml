open OUnit2
open Data
open List
open TestUtils

let test_high_order_1 ctxt =
  let x = [5;6;7;3] in
  let y = [5;6;7;5] in
  let z = [7;5;6;5] in
  let a = [3;5;8;9] in

  assert_equal 0 @@ count 2 x;
  assert_equal 1 @@ count 3 x;
  assert_equal 1 @@ count 5 x;
  assert_equal 0 @@ count 2 y;
  assert_equal 0 @@ count 3 y;
  assert_equal 2 @@ count 5 y;
  assert_equal 0 @@ count 2 z;
  assert_equal 0 @@ count 3 z;
  assert_equal 2 @@ count 5 z;
  assert_equal 0 @@ count 2 a;
  assert_equal 1 @@ count 3 a;
  assert_equal 1 @@ count 5 a;

  assert_equal [false;true;false;false] @@ divisible_by 2 x;
  assert_equal [false;true;false;true] @@ divisible_by 3 x;
  assert_equal [true;false;false;false] @@ divisible_by 5 x;
  assert_equal [false;true;false;false] @@ divisible_by 2 y;
  assert_equal [false;true;false;false] @@ divisible_by 3 y;
  assert_equal [true;false;false;true] @@ divisible_by 5 y;
  assert_equal [false;false;true;false] @@ divisible_by 2 z;
  assert_equal [false;false;true;false] @@ divisible_by 3 z;
  assert_equal [false;true;false;true] @@ divisible_by 5 z;
  assert_equal [false;false;true;false] @@ divisible_by 2 a;
  assert_equal [true;false;false;true] @@ divisible_by 3 a;
  assert_equal [false;true;false;false] @@ divisible_by 5 a;

  assert_equal [true;false;false;false] @@ divisible_by_first x;
  assert_equal [true;false;false;true] @@ divisible_by_first y;
  assert_equal [true;false;false;false] @@ divisible_by_first z;
  assert_equal [true;false;false;true] @@ divisible_by_first a

let test_high_order_2 ctxt =
  let x = [5;6;7;3] in
  let y = [5;6;7;5] in
  let z = [7;5;6;5] in
  let a = [3;5;8;9] in

  let l1 = [1] in
  let l2 = [1;2] in
  let l3 = [1;2;5] in
  let l4 = [3;4] in
  let l5 = [1;2] in
  let l6 = [3;4;5] in
  let l7 = ["a";"b"] in
  let l8 = ["c";"d"] in
  let l9 = ["Hello";"Goodbye"] in
  let l0 = ["Nolan!";"Charles!";"Anwar!";"World!"] in

  assert_equal [(1,1)] @@ pairup l1 l1;
  assert_equal [(1,1);(1,2);(2,1);(2,2)] @@ pairup l2 l2;
  assert_equal [(1,3);(1,4);(2,3);(2,4);(5,3);(5,4)] @@ pairup l3 l4;
  assert_equal [(1,3);(1,4);(1,5);(2,3);(2,4);(2,5)] @@ pairup l5 l6;
  assert_equal [("a","c");("a","d");("b","c");("b","d")] @@ pairup l7 l8;
  assert_equal [("Hello","Nolan!");("Hello","Charles!");("Hello","Anwar!");("Hello","World!");("Goodbye","Nolan!");("Goodbye","Charles!");("Goodbye","Anwar!");("Goodbye","World!")] @@ pairup l9 l0;

  assert_equal [3;5;8;9;7;5;6;5] @@ concat_lists [a;z]; 
  assert_equal [5;6;7;3;3;5;8;9;7;5;6;5] @@ concat_lists [x;a;z]; 
  assert_equal [5;6;7;5;3;5;8;9;3;5;8;9;7;5;6;5] @@ concat_lists [y;a;a;z]; 
  assert_equal [[3;5;8;9];[7;5;6;5]] @@ concat_lists [[a];[z]]; 
  assert_equal [[3;5;8;9];[5;6;7;5];[7;5;6;5];[5;6;7;3]] @@ concat_lists [[a;y];[z;x]]; 
  assert_equal [[3;5;8;9];[5;6;7;5];[3;5;8;9];[7;5;6;5];[5;6;7;3]] @@ concat_lists [[a;y];[a];[z;x]]

let test_int_tree ctxt =
  let t0 = empty_int_tree in
  let t1 = (int_insert 2 (int_insert 1 t0)) in
  let t2 = (int_insert 3 t1) in
  let t3 = (int_insert 5 (int_insert 3 (int_insert 11 t2))) in
  let x = [5;6;8;3;0] in
  let z = [7;5;6;5;1] in
  let t4a = int_insert_all x t1 in
  let t4b = int_insert_all z t1 in

  assert_equal 0 @@ (int_size t0);
  assert_equal 2 @@ (int_size t1);
  assert_equal 3 @@ (int_size t2);
  assert_equal 5 @@ (int_size t3);

  assert_raises (Invalid_argument("int_max")) (fun () -> int_max t0);
  assert_equal 2 @@ int_max t1;
  assert_equal 3 @@ int_max t2;
  assert_equal 11 @@ int_max t3;

  assert_equal [true;true;true;true;true] @@ map (fun y -> int_mem y t4a) x;
  assert_equal [true;true;false;false;false] @@ map (fun y -> int_mem y t4b) x;
  assert_equal [false;true;true;true;true] @@ map (fun y -> int_mem y t4a) z;
  assert_equal [true;true;true;true;true] @@ map (fun y -> int_mem y t4b) z

let test_int_common_1 ctxt =
  let p0 = empty_int_tree in     
  let p1 = (int_insert 2 (int_insert 5 p0)) in
  let p3 = (int_insert 10 (int_insert 3 (int_insert 11 p1))) in
  let p4 = (int_insert 15 p3) in
  let p5 = (int_insert 1 p4) in

  assert_equal 5 @@ int_common p5 1 11;
  assert_equal 5 @@ int_common p5 1 10;
  assert_equal 5 @@ int_common p5 2 10;
  assert_equal 2 @@ int_common p5 2 3;
  assert_equal 11 @@ int_common p5 10 11;
  assert_equal 11 @@ int_common p5 11 11

let test_int_common_2 ctxt =
  let q0 = empty_int_tree in
  let q1 = (int_insert 3 (int_insert 8 q0)) in
  let q2 = (int_insert 2 (int_insert 6 q1)) in
  let q3 = (int_insert 12 q2) in
  let q4 = (int_insert 16 (int_insert 9 q3)) in

  assert_equal 3 @@ int_common q4 2 6;
  assert_equal 12 @@ int_common q4 9 16;
  assert_equal 8 @@ int_common q4 2 9;
  assert_equal 8 @@ int_common q4 3 8;
  assert_equal 8 @@ int_common q4 6 8; 
  assert_equal 8 @@ int_common q4 12 8;
  assert_equal 8 @@ int_common q4 8 16

let test_ptree ctxt = 
  let r0 = empty_ptree Pervasives.compare in
  let r1 = (pinsert 2 (pinsert 1 r0)) in
  let r2 = (pinsert 3 r1) in
  let r3 = (pinsert 5 (pinsert 3 (pinsert 11 r2))) in
  let a = [5;6;8;3;11;7;2;6;5;1]  in

  let strlen_comp x y = Pervasives.compare (String.length x) (String.length y) in
  let k0 = empty_ptree strlen_comp in
  let k1 = (pinsert "hello" (pinsert "bob" k0)) in
  let k2 = (pinsert "sidney" k1) in
  let k3 = (pinsert "yosemite" (pinsert "ali" (pinsert "alice" k2))) in
  let b = ["hello"; "bob"; "sidney"; "kevin"; "james"; "ali"; "alice"; "xxxxxxxx"] in

  assert_equal [false;false;false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y r0) a;
  assert_equal [false;false;false;false;false;false;true;false;false;true] @@ map (fun y -> pmem y r1) a;
  assert_equal [false;false;false;true;false;false;true;false;false;true] @@ map (fun y -> pmem y r2) a;
  assert_equal [true;false;false;true;true;false;true;false;true;true] @@ map (fun y -> pmem y r3) a;

  assert_equal [false;false;false;false;false;false;false;false] @@ map (fun y -> pmem y k0) b;
  assert_equal [true;true;false;true;true;true;true;false] @@ map (fun y -> pmem y k1) b;
  assert_equal [true;true;true;true;true;true;true;false] @@ map (fun y -> pmem y k2) b;
  assert_equal [true;true;true;true;true;true;true;true] @@ map (fun y -> pmem y k3) b

let test_graph_1 ctxt =
  let g = add_edges
      [ { src = 1; dst = 2; };
        { src = 2; dst = 3; };
        { src = 3; dst = 4; };
        { src = 4; dst = 5; } ] empty_graph in
  let g2 = add_edges
      [ { src = 1; dst = 2; };
        { src = 3; dst = 4; };
        { src = 4; dst = 3; } ] empty_graph in
  let g3 = add_edges
      [ { src = 1; dst = 2; };
        { src = 1; dst = 3; };
        { src = 3; dst = 2; };
        { src = 2; dst = 1; } ] empty_graph in

  assert_equal true @@ graph_empty empty_graph;
  assert_equal false @@ graph_empty g;
  assert_equal false @@ graph_empty g2;

  assert_equal 0 @@ graph_size empty_graph;
  assert_equal 5 @@ graph_size g;
  assert_equal 4 @@ graph_size g2;
  assert_equal 3 @@ graph_size g3

let test_graph_2 ctxt =
  let p = add_edges
      [ { src = 1; dst = 2; };
        { src = 2; dst = 3; };
        { src = 3; dst = 4; };
        { src = 4; dst = 5; } ] empty_graph in
  let p2 = add_edges
      [ { src = 1; dst = 2; };
        { src = 3; dst = 4; };
        { src = 4; dst = 3; } ] empty_graph in
  let p3 = add_edges
      [ { src = 1; dst = 2; };
        { src = 1; dst = 3; };
        { src = 3; dst = 2; };
        { src = 2; dst = 1; } ] empty_graph in

  assert_equal [2] @@ (map (fun { dst = d } -> d) (src_edges 1 p));
  assert_equal [3] @@ (map (fun { dst = d } -> d) (src_edges 2 p));
  assert_equal [] @@ (map (fun { dst = d } -> d) (src_edges 5 p));
  assert_equal [2] @@ (map (fun { dst = d } -> d) (src_edges 1 p2));
  assert_equal [] @@ (map (fun { dst = d } -> d) (src_edges 2 p2));
  assert_equal [4] @@ (map (fun { dst = d } -> d) (src_edges 3 p2));
  assert_equal [1] @@ (map (fun { dst = d } -> d) (src_edges 2 p3));
  assert_equal [] @@ (map (fun { dst = d } -> d) (src_edges 4 p3));
  assert_equal [2;3] @@ (map (fun { dst = d } -> d) (src_edges 1 p3));

  assert_equal [true] @@ (map (fun e -> is_dst 2 e) (src_edges 1 p));
  assert_equal [true] @@ (map (fun e -> is_dst 2 e) (src_edges 1 p2));
  assert_equal [true;false] @@ (map (fun e -> is_dst 2 e) (src_edges 1 p3))

let suite =
  "public" >::: [
    "high_order_1" >:: test_high_order_1;
    "high_order_2" >:: test_high_order_2;
    "int_tree" >:: test_int_tree;
    "common_1" >:: test_int_common_1;
    "common_2" >:: test_int_common_2;
    "ptree" >:: test_ptree;
    "graph_1" >:: test_graph_1;
    "graph_2" >:: test_graph_2
  ]

let _ = run_test_tt_main suite
