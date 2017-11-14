:- module(list,[
       product/2,
       flat/2,
       index/3,
       nodups/2,
       powerset/2
   ]).

% Predicate: product(List,Prod)
% Description: Prod is the product of every number in List.
% Assumptions: The product of the empty list is 1.
% Usage: If List is a list of integers, then Product(List,Prod) succeeds with a unique solution for Prod.

product(List,Prod) :-
    fail.

% Predicate: index(List,Elem,Index)
% Description: Index is the index of Elem in List.
% Assumptions: Index is a nonnegative integer.
% Usage: If List is a list, then index(List,Elem,Index) succeeds with all solutions for Elem and Index.
% Notes: In this case, order and uniqueness of solutions matters.
% Hints: Define a tail-recursive helper predicate.

index(List,Elem,Index) :-
    fail.

% Predicate: flat(NestedList,FlatList)
% Description: FlatList is the result of removing one level of nesting from NestedList.
% Usage: If NestedList is a list, then flat(NestedList,FlatList) succeeds with one solution for FlatList.

flat(NestedList,FlatList) :-
    fail.

% Predicate: nodups(List,Unique)
% Description: Unique is List with all duplicates removed.
% Notes: The order of elements in Unique is the order of elements in List.
% Usage: If List is a list, then nodups(List,Unique) succeeds with one solution for Unique.

nodups(List,Unique) :-
    fail.

% Predicate: powerset(Set,Sub)
% Description: Sub is an element of the powerset of Set
% Assumptions: Set and Pow are ordered lists without duplicates.
% Usage: If Set is an ordered list without duplicates, then powerset(Set,Sub) succeeds with all solutions for Sub.
% Notes: The powerset of a set S is the set of all subsets of S.
% Hints: Give a recursive definition of the powerset operation. In the recursive case, you must make one binary choice.

powerset(Set,Sub) :-
    fail.