open OUnit2
open Nfa
open Regexp
open TestUtils

let test_nfa_accept ctxt =

  let m1 = make_nfa 0 [1] [(0, Some 'a', 1)] in
  assert_nfa_deny m1 "";
  assert_nfa_accept m1 "a";
  assert_nfa_deny m1 "b";
  assert_nfa_deny m1 "ba";

  let m2 = make_nfa 0 [2] [(0, Some 'a', 1); (0, Some 'b', 2)] in
  assert_nfa_deny m2 "";
  assert_nfa_deny m2 "a";
  assert_nfa_accept m2 "b";
  assert_nfa_deny m2 "ba"

let test_nfa_to_dfa ctxt =

  let m1 = make_nfa 0 [1; 3] [(0, Some 'a', 1); (0, Some 'a', 2); (2, Some 'b', 3)] in
  let m1' = nfa_to_dfa m1 in
  assert_dfa m1';
  assert_nfa_deny m1' "";
  assert_nfa_accept m1' "a";
  assert_nfa_accept m1' "ab";
  assert_nfa_deny m1' "b";
  assert_nfa_deny m1' "ba";

  let m2 = make_nfa 0 [2] [(0, None, 1); (1, Some 'b', 2)] in
  let m2' = nfa_to_dfa m2 in
  assert_dfa m2';
  assert_nfa_deny m2' "";
  assert_nfa_deny m2' "a";
  assert_nfa_accept m2' "b";
  assert_nfa_deny m2' "ba"

let test_nfa_closure ctxt = 

  let m1 = make_nfa 0 [1] [(0, Some 'a', 1)] in
  assert_nfa_closure m1 [0] [0];
  assert_nfa_closure m1 [1] [1];

  let m2 = make_nfa 0 [1] [(0, None, 1)] in
  assert_nfa_closure m2 [0] [0;1];
  assert_nfa_closure m2 [1] [1];

  let m3 = make_nfa 0 [2] [(0, Some 'a', 1); (0, Some 'b', 2)] in
  assert_nfa_closure m3 [0] [0];
  assert_nfa_closure m3 [1] [1];
  assert_nfa_closure m3 [2] [2];

  let m4 = make_nfa 0 [2] [(0, None, 1); (0, None, 2)] in
  assert_nfa_closure m4 [0] [0;1;2];
  assert_nfa_closure m4 [1] [1];
  assert_nfa_closure m4 [2] [2]

let test_nfa_move ctxt =
  let m1 = make_nfa 0 [1] [(0, Some 'a', 1)] in
  assert_nfa_move m1 [0] 'a' [1];
  assert_nfa_move m1 [1] 'a' [];

  let m2 = make_nfa 0 [1] [(0, None, 1)] in
  assert_nfa_move m2 [0] 'a' [];
  assert_nfa_move m2 [1] 'a' [];

  let m3 = make_nfa 0 [2] [(0, Some 'a', 1); (0, Some 'b', 2)] in
  assert_nfa_move m3 [0] 'a' [1];
  assert_nfa_move m3 [1] 'a' [];
  assert_nfa_move m3 [2] 'a' [];
  assert_nfa_move m3 [0] 'b' [2];
  assert_nfa_move m3 [1] 'b' [];
  assert_nfa_move m3 [2] 'b' [];

  let m4 = make_nfa 0 [2] [(0, None, 1); (0, Some 'a', 2)] in
  assert_nfa_move m4 [0] 'a' [2];
  assert_nfa_move m4 [1] 'a' [];
  assert_nfa_move m4 [2] 'a' [];
  assert_nfa_move m4 [0] 'b' [];
  assert_nfa_move m4 [1] 'b' [];
  assert_nfa_move m4 [2] 'b' []

let test_re_to_nfa ctxt =

  let m1 = regexp_to_nfa (Char('a')) in
  assert_nfa_deny m1 "";
  assert_nfa_accept m1 "a";
  assert_nfa_deny m1 "b";
  assert_nfa_deny m1 "ba";

  let m2 = regexp_to_nfa (Union(Char('a'), Char('b'))) in
  assert_nfa_deny m2 "";
  assert_nfa_accept m2 "a";
  assert_nfa_accept m2 "b";
  assert_nfa_deny m2 "ba"

let test_re_to_str ctxt =

  let r1 = Concat(Char('a'), Char('b')) in
  assert_regex_string_equiv r1;

  let r2 = Union(Char('c'), Char('d')) in
  assert_regex_string_equiv r2;

  let r3 = Star(Char('e')) in
  assert_regex_string_equiv r3

let test_stats ctxt =

  let m1 = make_nfa 0 [1] [(0, Some 'a', 1)] in
  assert_stats m1 {num_states = 2; num_finals = 1; outgoing_counts = [(0, 1); (1, 1)]};

  let m2 = make_nfa 0 [2] [(0, Some 'a', 1); (0, Some 'b', 2)] in
  assert_stats m2 {num_states = 3; num_finals = 1; outgoing_counts = [(0, 2); (2, 1)]};

  let m3 = make_nfa 0 [2;3] [(0, Some 'a', 1); (0, Some 'b', 2); (1, Some 'c', 3); (2, Some 'a', 0); (2, Some 'b', 2); (2, Some 'c', 3)] in
  assert_stats m3 {num_states = 4; num_finals = 2; outgoing_counts = [(0, 1); (1, 1); (2, 1); (3, 1)]}

let test_str_to_nfa ctxt =
  let m1 = regexp_to_nfa @@ string_to_regexp "ab" in
  assert_nfa_deny m1 "a";
  assert_nfa_deny m1 "b";
  assert_nfa_accept m1 "ab";
  assert_nfa_deny m1 "bb"

let suite =
  "public" >::: [
    "nfa_accept" >:: test_nfa_accept;
    "nfa_to_dfa" >:: test_nfa_to_dfa;
    "nfa_closure" >:: test_nfa_closure;
    "nfa_move" >:: test_nfa_move;
    "re_to_nfa" >:: test_re_to_nfa;
    "re_to_str" >:: test_re_to_str;
    "stats" >:: test_stats;
    "str_to_nfa" >:: test_str_to_nfa
  ]

let _ = run_test_tt_main suite
