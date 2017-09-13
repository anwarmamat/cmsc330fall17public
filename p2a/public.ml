open OUnit2
open Basics
open TestUtils

let test_mult_of_y ctxt = 
  assert_equal true (mult_of_y 10 5);
  assert_equal false (mult_of_y 7 3);
  assert_equal false (mult_of_y 5 10)

let test_head_divisor ctxt =
  assert_equal true (head_divisor [8; 4; 10]);
  assert_equal false (head_divisor [7; 2]);
  assert_equal false (head_divisor [])

let test_second_element ctxt =
  assert_equal 20 (second_element [10; 20; 30]);
  assert_equal (-1) (second_element [])

let test_sum_first_three ctxt =
  assert_equal 18 (sum_first_three [7; 4; 7]);
  assert_equal 3 (sum_first_three [1; 2]);
  assert_equal 10 (sum_first_three [10]);
  assert_equal 5 (sum_first_three [3; 2; 0; 10])

let test_unzip ctxt =
  assert_equal ([1;3], [2;4]) (unzip [(1,2); (3,4)]);
  assert_equal ([], []) (unzip [])

let test_get_val ctxt =
  assert_equal 5 (get_val 0 [5;6;7;3]);
  assert_equal (-1) (get_val 6 [5;6;7;3])

let test_get_vals ctxt =
  assert_equal [7;5] (get_vals [2;0] [5;6;7;3]);
  assert_equal [7;(-1)] (get_vals [2;4] [5;6;7;3])

let test_list_swap_val ctxt =
  assert_equal [7;6;5;3] (list_swap_val [5;6;7;3] 7 5);
  assert_equal [3;2;1] (list_swap_val [3;2;1] 8 9) 

let test_index ctxt =
  assert_equal 0 (index 1 [1;2]) ;
  assert_equal (-1) (index 5 [1;2;3]) 

let test_card ctxt =
  assert_equal 0 @@ card (create_set []);
  assert_equal 2 @@ card (create_set [2;3])

let test_elem ctxt =
  assert_false @@ elem 3 (create_set []);
  assert_true @@ elem 5 (create_set [2;3;5;7;9]);
  assert_false @@ elem 4 (create_set [2;3;5;7;9])

let test_remove ctxt =
  assert_set_equal (create_set []) @@ remove 5 (create_set []);
  assert_set_equal (create_set [2;3;7;9]) @@ remove 5 (create_set [2;3;5;7;9]);
  assert_set_equal (create_set [2;3;5;7;9]) @@ remove 4 (create_set [2;3;5;7;9])

let test_union ctxt =
  assert_set_equal (create_set [2;3;5]) @@ union (create_set []) (create_set [2;3;5]);
  assert_set_equal (create_set [2;3;5;7;9]) @@ union (create_set [2;5]) (create_set [3;7;9]);
  assert_set_equal (create_set [2;3;7;9]) @@ union (create_set [2;3;9]) (create_set [2;7;9])

let test_intersection ctxt =
  assert_set_equal (create_set []) @@ intersection (create_set [2;3;5]) (create_set []);
  assert_set_equal (create_set []) @@ intersection (create_set [3;7;9]) (create_set [2;5]);
  assert_set_equal (create_set [5]) @@ intersection (create_set [2;5;9]) (create_set [3;5;7]) 

let test_subset ctxt =
  assert_true @@ subset (create_set []) (create_set [2;3;5;7;9]);
  assert_true @@ subset (create_set [3;5]) (create_set [2;3;5;7;9]);
  assert_false @@ subset (create_set [4;5]) (create_set [2;3;5;7;9])

let suite =
  "public" >::: [
    "mult_of_y" >:: test_mult_of_y;
    "head_divisor" >:: test_head_divisor;
    "second_element" >:: test_second_element;
    "sum_first_three" >:: test_sum_first_three;

    "prod" >:: test_prod;
    "get_val" >:: test_get_val;
    "get_vals" >:: test_get_vals;
    "list_swap_val" >:: test_list_swap_val;
    "index" >:: test_index;

    "card" >:: test_card;
    "elem" >:: test_elem;
    "remove" >:: test_remove;
    "union" >:: test_union;
    "intersection" >:: test_intersection;
    "subset" >:: test_subset
  ]

let _ = run_test_tt_main suite
