:- module(arith,[
       gcd/3,
       factor/2,
       prime/1,
       partition/2
   ]).

% Predicate: factor(N,F)
% Description: F is a factor of N.
% Assumptions: N and F are positive integers.
% Notes: F is a factor of N iff N = K * F for some integer K.
% Usage: If N and F are positive integers, then factor(N,F) succeeds with all solutions for F.

factor(N,F) :-
    fail.

% Predicate: gcd(A,B,D)
% Description: D is the greatest common divisor of A and B.
% Assumptions: A and B are nonnegative integers.
% Notes: Use the Euclidean algorithm to compute gcd(A,B,D).
% Usage: If A and B are nonnegative integers, then gcd(A,B,D) succeeds with one solution for D.


gcd(A,B,D) :-
    fail.

% Predicate: prime(N)
% Description: N is prime.
% Assumptions: N is a nonnegative integer.
% Notes: N is prime iff its only positive factors are 1 and N.
% Usage: If N is a nonnegative integer, then prime(N) succeeds iff N is prime.

prime(N) :-
    fail.

% Predicate: partition(N,Part)
% Description: Part is a partition of N into primes.
% Assumptions: N is a positive integer and Part an ordered list of distinct positive integers.
% Notes: A partition of a positive integer N is a set S of positive integers such that S sums to N.
% Usage: If N is a positive integer, then partition(N,Part) succeeds with all solutions for Part.
% Hints: Compare your solution against OEIS A000586 for a quick sanity check.

partition(N,Part) :-
    fail.