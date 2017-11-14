:- use_module(library(plunit)).

:- begin_tests(public_factor).
:- use_module(arith,[factor/2]).

test(factor_one,[nondet]) :-
    factor(1,1).

test(factor_prime_small,[set(F == [1,17])]) :-
    factor(17,F).

test(factor_prime_larger,[set(F == [1,67])]) :-
    factor(67,F).

test(factor_composite_small,[set(F == [1,2,3,6,9,18])]) :-
    factor(18,F).

test(factor_composite_larger,[set(F == [1,2,4,17,34,68])]) :-
    factor(68,F).

:- end_tests(public_factor).

:- begin_tests(public_gcd).
:- use_module(arith,[gcd/3]).

test(gcd_zero,[nondet]) :-
    gcd(0,0,0).

test(gcd_zero_left,[nondet]) :-
    gcd(0,5,5).

test(gcd_coprime,[nondet]) :-
    gcd(12,25,1).

test(gcd_divisor,[nondet]) :-
    gcd(14,21,7).

test(gcd_divisor,[nondet]) :-
    gcd(24,54,6).

:- end_tests(public_gcd).

:- begin_tests(public_prime).
:- use_module(arith,[prime/1]).

test(prime_one,[fail]) :-
    prime(1).

test(prime_small,[nondet]) :-
    prime(137).

test(prime_larger,[nondet]) :-
    prime(1009).

test(prime_composite_small,[fail]) :-
    prime(133).

test(prime_composite_larger,[fail]) :-
    prime(1001).

:- end_tests(public_prime).

:- begin_tests(public_partition).
:- use_module(arith,[partition/2]).

test(partition_fail_one,[fail]) :-
    partition(1,_).

test(partition_fail_four,[fail]) :-
    partition(4,_).

test(partition_true_small,[set(P == [[2,5],[7]])]) :-
    partition(7,P).

test(partition_true_seven,[set(P == [[2,7]])]) :-
    partition(9,P).

test(partition_true_larger,[set(P == [[2,3,5,17],[2,5,7,13],[3,5,19],[3,7,17],[3,11,13]])]) :-
    partition(27,P).

:- end_tests(public_partition).

:- begin_tests(public_product).
:- use_module(list,[product/2]).

test(public_product_empty,[nondet]) :-
    product([],1).

test(public_product_single,[nondet]) :-
    product([5],5).

test(public_product_primorial_1,[nondet]) :-
    product([2,3,5],30).

test(public_product_primorial_2,[nondet]) :-
    product([2,3,5,7],210).

test(public_product_unordered,[nondet]) :-
    product([7,5,5,7],1225).

:- end_tests(public_product).

:- begin_tests(public_index).
:- use_module(list,[index/3]).

test(public_index_empty,[fail]) :-
    index([],_,_).

test(public_index_find_zero,[all(X == [a])]) :-
    index([a,b,a,c,b,a],X,0).

test(public_index_find_three,[all(X == [c])]) :-
    index([a,b,a,c,b,a],X,3).

test(public_index_find_elem,[all(I == [1,4])]) :-
    index([a,b,a,c,b,a],b,I).

test(public_index_enum,[all(I-X == [0-a,1-b,2-a,3-c,4-b,5-a])]) :-
    index([a,b,a,c,b,a],X,I).

:- end_tests(public_index).

:- begin_tests(public_flat).
:- use_module(list,[flat/2]).

test(flat_empty,[nondet]) :-
    flat([],[]).

test(flat_ident,[nondet]) :-
    flat([1,2,3,4,5],[1,2,3,4,5]).

test(flat_nest,[nondet]) :-
    flat([[1,2],[3],[4,5]],[1,2,3,4,5]).

test(flat_empty,[nondet]) :-
    flat([[1,2],[],[3],[4,5]],[1,2,3,4,5]).

test(flat_deep,[nondet]) :-
    flat([[1,[2]],[[]],[3],[[4,5]]],[1,[2],[],3,[4,5]]).

:- end_tests(public_flat).

:- begin_tests(public_nodups).
:- use_module(list,[nodups/2]).

test(nodups_empty,[nondet]) :-
    nodups([],[]).

test(nodups_unique,[nondet]) :-
    nodups([4,1,3,2],[4,1,3,2]).

test(nodups_sorted,[nondet]) :-
    nodups([1,1,2,3,3,3,4],[1,2,3,4]).

test(nodups_order_left,[nondet]) :-
    nodups([1,3,2,3,1],[1,3,2]).

test(nodups_order_right,[nondet]) :-
    nodups([1,2,3,2,1],[1,2,3]).

:- end_tests(public_nodups).

:- begin_tests(public_powerset).
:- use_module(list,[powerset/2]).

test(powerset_empty,[nondet]) :-
    powerset([],[]).

test(powerset_base,[nondet]) :-
    powerset([1,2,3],[]).

test(powerset_single,[nondet]) :-
    powerset([1,2,3],[2]).

test(powerset_set,[nondet]) :-
    powerset([1,2,3],[1,2,3]).

test(powerset_all,[set(S == [[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]])]) :-
    powerset([1,2,3],S).

:- end_tests(public_powerset).

:- begin_tests(public_eval_expr).
:- use_module(opsem,[interpret_expr/5]).

test(eval_expr_arith,[nondet]) :-
    interpret_expr("1 * 2 + 3 * 4",[],[],int,14).

test(eval_expr_bool,[nondet]) :-
    interpret_expr("false || !!false",[],[],bool,false).

test(eval_expr_lt,[nondet]) :-
    interpret_expr("1 + 2 < 3 * 2",[],[],bool,true).

test(test_eq,[nondet]) :-
    interpret_expr("(0 == 1) == true",[],[],bool,false).

test(test_ident,[nondet]) :-
    interpret_expr("x < 2 || !p == true",[x-int,p-bool],[x-3,p-true],bool,false).

:- end_tests(public_eval_expr).

:- begin_tests(public_eval_stmt).
:- use_module(opsem,[interpret_stmt/4]).

check_environment(Bindings,Env) :-
    ground(Env),
    forall(
        member(K-V,Bindings),
        lookup(Env,K,V)
    ).

lookup([K-V|_],K,V) :-
    !.
lookup([_|Rest],K,V) :-
    lookup(Rest,K,V).

test(eval_stmt_declare,[nondet]) :-
    interpret_stmt("int x; bool p;",[],[],Env),
    check_environment([x-0,p-false],Env).

test(eval_stmt_assign,[nondet]) :-
    interpret_stmt("x = 1; p = true; x = 2;",[x-int,p-bool],[x-0,p-false],Env),
    check_environment([x-2,p-true],Env).

test(eval_stmt_while,[nondet]) :-
    interpret_stmt("int x; int n; x = 1; n = 4; while (0 < n) {x = x * n; n = n + (-1);}",[],[],Env),
    check_environment([x-24,n-0],Env).

test(eval_stmt_cond_then,[nondet]) :-
    interpret_stmt("if (x < x || p) {x = x + 1;} else {x = x + 2;}",[x-int,p-bool],[x-0,p-true],Env),
    check_environment([x-1,p-true],Env).

test(eval_stmt_cond_else,[nondet]) :-
    interpret_stmt("if (x < x || p) {x = x + 1;} else {x = x + 2;}",[x-int,p-bool],[x-0,p-false],Env),
    check_environment([x-2,p-false],Env).

:- end_tests(public_eval_stmt).

nfa_third_last(nfa(Q,A,D,S,F)) :-
    Q = [0,1,2,3],
    A = [a,b],
    D = [(0,a,0),(0,b,0),(0,a,1),(1,a,2),(1,b,2),(2,a,3),(2,b,3)],
    S = 0,
    F = [3].

nfa_free(nfa(Q,A,D,S,F)) :-
    Q = [0],
    A = [a,b],
    D = [(0,a,0),(0,b,0)],
    S = 0,
    F = [0].

nfa_dead(nfa(Q,A,D,S,F)) :-
    Q = [0,1,2],
    A = [a,b,c],
    D = [(0,a,1),(0,b,1),(0,c,2),(1,a,1),(1,b,1),(1,c,2)],
    S = 0,
    F = [1].

nfa_suffix_epsilon(nfa(Q,A,D,S,F)) :-
    Q = [0,1,2,3,4,5,6],
    A = [a,b],
    D = [(0,epsilon,1),(0,epsilon,2),(0,epsilon,5),(1,a,3),(2,b,4),(3,epsilon,5),(4,epsilon,5),(5,epsilon,0),(5,a,6)],
    S = 0,
    F = [6].

:- begin_tests(public_move).
:- use_module(nfa,[move/4]).

test(move_ground,[nondet]) :-
    nfa_third_last(M),
    move(M,0,a,0).

test(move_epsilon_fail,[fail]) :-
    nfa_suffix_epsilon(M),
    move(M,0,epsilon,1).

test(move_enum_from,[set(A-I == [a-0,a-1,b-0])]) :-
    nfa_third_last(M),
    move(M,0,A,I).

test(move_enum_on,[set(I-J == [0-0,0-1,1-2,2-3])]) :-
    nfa_third_last(M),
    move(M,I,a,J).

test(move_enum_all,[set((I,A,J) == [(1,a,3),(2,b,4),(5,a,6)])]) :-
    nfa_suffix_epsilon(M),
    move(M,I,A,J).

:- end_tests(public_move).

:- begin_tests(public_closure).
:- use_module(nfa,[e_closure/3]).

test(closure_no_epsilon,[set(I-J == [0-0,1-1,2-2,3-3])]) :-
    nfa_third_last(M),
    e_closure(M,I,J).

test(closure_ground,[nondet]) :-
    nfa_suffix_epsilon(M),
    e_closure(M,0,5).

test(closure_start,[set(I == [0,1,2,5])]) :-
    nfa_suffix_epsilon(M),
    e_closure(M,0,I).

test(closure_middle,[set(I == [0,1,3,2,5])]) :-
    nfa_suffix_epsilon(M),
    e_closure(M,3,I).

test(closure_from,[set(I == [0,3,4,5])]) :-
    nfa_suffix_epsilon(M),
    e_closure(M,I,5).

:- end_tests(public_closure).

:- begin_tests(public_accept).
:- use_module(nfa,[accept/2]).

test(accept_notin_empty,[fail]) :-
    nfa_suffix_epsilon(M),
    accept(M,[]).

test(accept_in_empty,[nondet]) :-
    nfa_free(M),
    accept(M,[]).

test(accept_notin_short,[fail]) :-
    nfa_suffix_epsilon(M),
    accept(M,[b,a,b]).

test(accept_in_epsilon,[nondet]) :-
    nfa_suffix_epsilon(M),
    accept(M,[a,b,b,a]).

test(accept_in_noepsilon,[nondet]) :-
    nfa_third_last(M),
    accept(M,[b,a,b,b]).

:- end_tests(public_accept).

:- begin_tests(public_productive).
:- use_module(nfa,[productive/2]).

test(productive_fail,[fail]) :-
    nfa_dead(M),
    productive(M,2).

test(productive_ground,[nondet]) :-
    nfa_dead(M),
    productive(M,0).

test(productive_nofinal,[fail]) :-
    nfa_suffix_epsilon(nfa(Q,A,D,S,_)),
    productive(nfa(Q,A,D,S,[]),_).

test(productive_enum_dead,[set(I == [0,1])]) :-
    nfa_dead(M),
    productive(M,I).

test(productive_enum_loop,[set(I == [0,1,2,3,4,5,6])]) :-
    nfa_suffix_epsilon(M),
    productive(M,I).

:- end_tests(public_productive).

:- begin_tests(public_nfa_enumerate).
:- use_module(nfa,[enumerate/3]).

test(enumerate_suffix_empty,[fail]) :-
    nfa_suffix_epsilon(M),
    enumerate(M,0,_).

test(enumerate_suffix_one,[set(U == [[a]])]) :-
    nfa_suffix_epsilon(M),
    enumerate(M,1,U).

test(enumerate_suffix_two,[set(U == [[a,a],[b,a]])]) :-
    nfa_suffix_epsilon(M),
    enumerate(M,2,U).

test(enumerate_suffix_three,[set(U == [[a,a,a],[a,b,a],[b,a,a],[b,b,a]])]) :-
    nfa_suffix_epsilon(M),
    enumerate(M,3,U).

test(enumerate_suffix_length,[set(L == [7])]) :-
    nfa_suffix_epsilon(M),
    enumerate(M,L,[b,a,a,b,a,b,a]).

:- end_tests(public_nfa_enumerate).
