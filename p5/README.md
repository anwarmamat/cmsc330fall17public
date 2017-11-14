# Project 5: Prolog
CMSC 330, Fall 2017 (Due December 4th, 2017)

Ground Rules
------------
This **is** a pair project. You may work with one other person, but make sure you both make your own submissions, as you will still be graded independently.

1. You can use any built-in [arithmetic](http://www.swi-prolog.org/pldoc/man?section=arith) or [list](http://www.swi-prolog.org/pldoc/man?section=builtinlist) predicate, in addition to any predicate defined [`library(lists)`](http://www.swi-prolog.org/pldoc/man?section=lists). Do not use additional libraries or syntactic extensions (unless given permission by an instructor, which is unlikely).

2. If asked to generate multiple solutions, the order and uniqueness of solutions is irrelevant unless specified otherwise. If a predicate should succeed deterministically, you are not required to prune redundant choice points provided that no _distinct_ solutions are generated on backtracking. Your code is tested by inspecting sets of solutions using extra-logical predicates.

Introduction
------------
Welcome to Prolog! This project contains five sections: arithmetic, lists, binary trees, operational semantics and finite automata. Each section begins with familiar exercises, mostly drawn from previous projects, so that solutions can be adapted and compared between OCaml and Prolog. The exercises in each section are arranged in roughly increasing difficulty. Tests are independent between sections, so you can skip between them without worrying about dependencies.

This project is organized into five [modules](http://www.swi-prolog.org/pldoc/man?section=modules), which are collections of predicated satisfying an interface. The [`module/2`](http://www.swi-prolog.org/pldoc/man?section=defmodule) directive occurring at the beginning of each source file declares the module name and interface. For example, the file `arith.pl` defines a module named `arith` that exports the predicates `gcd/3`, `factor/2`, `prime/1` and `partition/1`. The [use_module/1](http://www.swi-prolog.org/pldoc/man?section=import) directive imports all predicates defined by a module, making them available in the current module or toplevel session.

Project Files
------------
To begin this project, you will need to commit any uncommitted changes to your local branch and pull updates from the git repository. [Click here for directions on working with the Git repository.][git instructions] The following are the relevant files:

- Prolog files (you should edit)
  - **arith.pl**: This file is the place you will implement part 1, the arithmetic module.
  - **list.pl**:  This file is the place you will implement part 2, the list module.
  - **opsem.pl**:  This file is the place you will implement part 3, the operational semantics module.
  - **nfa.pl**:  This file is the place you will implement part 4, the finite automata module.
- Provided Prolog files (no need to edit, changes will be overwritten!)
  - **lexer.pl**: This file implements the SmallC lexer.
  - **parser.pl**: This file implements the SmallC parser.
  - **public.pl**: The public test driver file.
- Submission Scripts and Other Files
  - **submit.rb**: Execute this script to submit your project to the submit server.
  - **submit.jar** and **.submit**: Don't worry about these files, but make sure you have them.
  - **pack_submission.sh**: Execute this script to zip your project for web submission.

Tests and Running
-------------------------------
The public tests can be run by executing `swipl -f public.pl -t run_tests`.

You can test any module from the Prolog toplevel. Run `swipl` and load any of your modules. For example, to load the arithmetic module execute `[arith].`. Assuming no errors, you will now be able to use any of your predicates.

General Advice
--------------
1. Many library predicates, including [`member/2`](http://www.swi-prolog.org/pldoc/man?predicate=member/2), [`append/3`](http://www.swi-prolog.org/pldoc/doc_for?object=append/3) and [`length/2`](http://www.swi-prolog.org/pldoc/doc_for?object=length/2) can be "run backwards" or used as generators. The predicate [`between/3`](http://www.swi-prolog.org/pldoc/man?predicate=between/3) generates all integers in a possibly infinite range when its third argument is uninstantiated (i.e., a variable). Understanding the behavior of these predicates will be immensely helpful in completing this project.

2. The predicates [`findall/3`](http://www.swi-prolog.org/pldoc/man?predicate=findall/3), [`bagof/3`](http://www.swi-prolog.org/pldoc/man?predicate=bagof/3) and [`setof/3`](http://www.swi-prolog.org/pldoc/doc_for?object=setof/3) reason about all solutions to a goal. We suggest reading the documentation for `setof/3`, because it behaves differently than `findall/3` when the goal has no solutions or contains free variables. Use [`forall/2`](http://www.swi-prolog.org/pldoc/doc_for?object=forall/2) to determine whether a goal succeeds for every instantiation of its free variables.

Part 1: Arithmetic (arith.pl)
-----------------------------
In this section, you will implement four predicates: `factor/2`, `gcd/3`, `prime/1` and `partition/2`. You have encountered `factor/2` under the name [`mult_of_y`](https://github.com/anwarmamat/cmsc330fall17public/tree/master/p2a#mult_of_y-x-y) in Project 2(a). Here, you must not only determine whether one number is a factor of another, but generate all factors of a number. You will find the predicate `between/3` useful for this purpose. The predicate `prime/1` has a natural but inefficient implementation in terms of `factor/2`. Although you aren't tested for efficiency, we challenge you to provide efficient implementations of `factor/2` and `prime/1`. If you have trouble implementing `partition/2`, consider returning after completing the list exercises.

- **Predicate:** `factor(N,F)`
- **Description:** `F` is a factor `N`.
- **Assumptions:** `N` and `F` are positive integers.
- **Notes:** `F` is a factor of `N` if `N = K * F` for some integer `K`.
- **Usage:** If `N` and `F` are positive integers, then `factor(N,F)` succeeds with all solutions for `F`.

```
?- factor(68,17).
true.

?- factor(17,68).
false.

?- setof(F,factor(68,F),Factors).
Factors = [1, 2, 4, 17, 34, 68].
```

- **Predicate:** `gcd(A,B,D)`
- **Description:** `D` is the greatest common divisor of `A` and `B`.
- **Assumptions:** `A` and `B` are nonnegative integers.
- **Notes:** Use the [Euclidean algorithm](https://en.wikipedia.org/wiki/Euclidean_algorithm#Implementations) to compute `gcd(A,B,D)`.
- **Usage:** If `A` and `B` are nonnegative integers, then `gcd(A,B,D)` succeeds with one solution for `D`.

```
?- gcd(8,0,D).
D = 8.

?- gcd(8,9,D).
D = 1.

?- gcd(12,15,D).
D = 3.
```

- **Predicate:** `prime(N)`
- **Description:** `N` is prime.
- **Assumptions:** `N` is a nonnegative integer.
- **Notes:** `N` is prime iff its only positive factors are `1` and `N`.
- **Usage:** If `N` is a nonnegative integer, then `prime(N)` succeeds iff `N` is prime.

```
?- prime(0).
false.

?- prime(7).
true.

?- setof(P,(between(0,10,P),prime(P)),Primes).
Primes = [2, 3, 5, 7]
```

- **Predicate:** `partition(N,Part)`
- **Description:** `Part` is a partition of `N` into distinct primes.
- **Assumptions:** `N` is a positive integer and `Part` an ordered list of _distinct_ positive integers.
- **Notes:** A partition of a positive integer `N` is a set `S` of positive integers such that `S` sums to `N`.
- **Usage:** If `N` is a positive integer, then `partition(N,Part)` succeeds with all solutions for `Part`.
- **Hints:** Compare your solution against [OEIS A000586](https://oeis.org/A000586) for a quick sanity check.

```
?- partition(4,Part).
false.

?- partition(8,Part).
Part = [3, 5].

?- setof(Part,partition(7,Part),Parts).
Parts = [[2, 5], [7]].
```

Part 2: Lists (list.pl)
-----------------------
In this section, you will implement five predicates: `product/2`, `index/3`, `flat/2`, `nodups/2` and `powerset/2`. We require that `index/3` work in a variety of modes and `flat/2` on heterogeneous lists.

- **Predicate:** `product(List,Prod)`
- **Description:** `Prod` is the product of every number in `List`.
- **Assumptions:** The product of the empty list is `1`.
- **Usage:** If `List` is a list of integers, then `Product(List,Prod)` succeeds with a unique solution for `Prod`.

```
?- product([],Prod).
Prod = 1.

?- product([1,2,3],Prod).
Prod = 6.

?- product([5,5,4],Prod).
Prod =  100.
```

- **Predicate:** `index(List,Elem,Index)`
- **Description:** `Index` is the index of `Elem` in List.
- **Assumptions:** `Index` is a nonnegative integer.
- **Notes:** In this case, order and uniqueness of solutions matters
- **Usage:** If `List` is a list, then `index(List,Elem,Index)` succeeds with all solutions for `Elem` and `Index`.
- **Hints:** Define a tail-recursive helper predicate.

```
?- index([],Elem,Index).
false.

?- findall(Index,index([1,2,1,2],2,Index),Indices).
Indices = [1, 3].

?- findall((Elem,Index),index([1,2,1,2],Elem,Index),Pairs).
Pairs = [(1, 0),  (2, 1),  (1, 2),  (2, 3)].
```

<!-- MWH: Explain the use X-Y here? Not something we normally cover, and it comes up again below. -->
<!-- Changed to (X,Y) -->
<!-- MWH: General question, what if List is not a list? We don't say how errors are handled. Perhaps emphasize we won't test that? -->

- **Predicate:** `flat(NestedList,FlatList)`
- **Description:** `FlatList` is the result of removing one level of nesting from `NestedList`.
- **Usage:** If `NestedList` is a list, then `flat(NestedList,FlatList)` succeeds with one solution for `FlatList`.

```
?- flat([],FlatList).
FlatList = [].

?- flat([1,[3]],FlatList).
FlatList = [1, 3].

?- flat([1,[[2],3],[4,[]]],FlatList).
FlatList = [1, [2], 3, 4, []].
```

- **Predicate:** `nodups(List,Unique)`
- **Description:** `Unique` is `List` with all duplicates removed.
- **Notes**: The order of elements in `Unique` is the order of elements in `List`.
- **Usage:** If `List` is a list, then `nodups(List,Unique)` succeeds with one solution for `Unique`.

```
?- nodups([],Unique).
Unique = [].

?- nodups([2,3,2],Unique).
Unique = [2, 3].

?- nodups([3,2,3],Unique).
Unique =  [3, 2].
```

- **Predicate:** `powerset(Set,Sub)`
- **Description:** `Sub` is an element of the powerset of `Set`
- **Assumptions:** `Set` and `Pow` are ordered lists without duplicates.
- **Notes:** The powerset of a set `S` is the set of all subsets of `S`.
- **Usage:** If `Set` is an ordered list without duplicates, then `powerset(Set,Sub)` succeeds with all solutions for `Sub`
- **Hints:** Give a recursive definition of the powerset operation. There is one binary choice in the recursive case.

```
?- powerset([],Sub).
Sub = [].

?- setof(Sub,powerset([1],Sub),Subs).
Subs = [[], [1]].

?- setof(Sub,powerset([1,2],Sub),Subs).
Subs = [[], [1], [1, 2], [2]].
```

Part 3: Operational Semantics (opsem.pl)
----------------------------------------
In this section, you will implement an interpreter for a fragment of SmallC. The key observation is that the semantics for SmallC are given by natural deduction rules, which are identical in structure to Prolog clauses. If this isn't obvious, consider reviewing the slides on [operational semantics](https://www.cs.umd.edu/class/spring2017/cmsc330/lectures/semantics.pdf) and [Prolog](https://www.cs.umd.edu/class/spring2017/cmsc330/lectures/prolog1.pdf) before beginning this section. Once you understand the relationship between the operational semantics and Prolog clauses, implementing the interpreter should be an exercise in translation.

We have provided a parser, type checker and driver to make testing your interpreter easier. The parser and type checker perform no error reporting. Thus, you can assume that all expressions and statements are well-typed with respect to the environment when implementing `eval_expr/3` and `eval_stmt/3`. You are only required to interpret the fragment of SmallC for which type checking has been implementing. For reference, `eval_expr/3` must support

- integers, represented `int(N)` where `N` is an integer;
- booleans, represented `bool(B)` where `B` is `true` or `false`;
- variables, represented `id(X)` where `X` is an atom;
- negation, represented `not(E)` where `E` is an expression;
- equality, represented `eq(E1,E2)` where `E1` and `E2` are expressions;
- inequality, represented `lt(E1,E2)` where `E1` and `E2` are expressions;
- disjunction, represented `or(E1,E2)` where `E1` and `E2` are expressions;
- addition, represented `plus(E1,E2)` where `E1` and `E2` are expressions; and
- multiplication, represented `mult(E1,E2)` where `E1` and `E2` are expressions.

Similarly, `eval_stmt/3` must support

- the empty statement, represented `skip`;
- sequencing, represented `seq(S1,S2)` where `S1` and `S2` are statements;
- variable declaration, represented `decl(T,X)` where `T` is one of `int` or `bool` and `X` is an atom;
- variable assignment, represented `assign(X,E)` where `X` is an atom and `E` an expression;
- while loops, represented `while(G,B)` where `G` is an expression and `B` a statement; and
- conditionals, represented `cond(G,T,E)` where `G` is an expression and `T` and `E` statements.

Environments are represented as association lists. The elements of an association list are pairs of the form `K-V` where `K` is a key and `V` the value. By convention, we say that `K` is bound to `V` in an environment `Env` if `V` is the leftmost binding for `K` in `Env`. The examples below assume that assignment doesn't overwrite variable bindings. Thus, your implementation may not match the examples exactly. The predicate `lookup/3` defined in `opsem.pl` returns the leftmost binding for a key in an association list.

The predicates `interpret_expr/6` and `interpret_stmt/4` can be used to test your implementation. You are referred to the documentation in `opsem.pl` for their full specification. To use `interpret_expr/5` and `interpret_stmt/4`, you must provide a string representation of an expression, a typing environment, and initial values for all free variables in the expression or statement. The string must be syntactically correct, the expression or statement well-typed in the typing environment, and the initial values consistent with the typing environment. As mentioned above, your interpreter operations under these assumptions; no error checking is required.

- **Predicate:** `eval_expr(Env,Expr,Value)`
- **Description:** `Expr` evaluates to value `Value` in environment `Env`.
- **Usage:** If `Env` is an environment and `Expr` a well-typed expression, then `eval_expr(Env,Expr,Value)` succeeds with one solution for `Value`.

```
?- interpret_expr("x + 1",[x-int],[x-2],Type,Value).
Type = int,
Value = 3.

?- interpret_expr("!p || p",[p-bool],[p-false],Type,Value).
Type = bool,
Value = true.

?- interpret_expr("x + 1 < 3 == p",[x-int,p-bool],[x-1,p-false],Type,Value).
Type = bool,
Value = false.
```

- **Predicate:** `eval_stmt(Env,Stmt,NewEnv)`
- **Description:** `NewEnv` is the result of evaluating `Stmt` in environment `Env`
- **Usage:** If `Env` is an environment and `Stmt` a well-typed statement, then `eval_stmt(Env,Stmt,NewEnv)` succeeds with one solution for `NewEnv`.

```
?- interpret_stmt("int x; x = 1;",[],[],Env).
Env = [x-1, x-0].

?- interpret_stmt("int x; bool p; if (x < 3) {x = x + 1; p = !p;}",[],[],Env).
Env = [p-true, x-1, p-false, x-0]

?- interpret_stmt("int f; f = 1; while (0 < n) {f = f * n; n = n + (-1);}",[n-int],[n-4],Env).
Env = [n-0, f-24, n-1, f-24, n-2, f-12, n-3, f-4, f-1, f-0, n-4].
```

Part 4: Finite Automata (nfa.pl)
--------------------------------
In this section, you will enumerate the strings of a regular language given an NFA for that language. You should find the implementation more natural in Prolog than OCaml, because Prolog executes queries by performing depth-first search  with backtracking. Thus, explicit data structures required to simulate nondeterminism in OCaml are largely implicit in Prolog. The only complication arises when dealing with epsilon-closures, because cycles in the transition graph may cause nontermination.

We adhere to the mathematical definition and represent an NFA `M` as a quintuple `nfa(Q,A,D,S,F)` where `Q` is a list of states, `A` the alphabet, `D` the transition relation, `S` the start state, and `F` the final states of `M`. The transition relation is a list of triples `(I,A,J)` having the obvious meaning, The atom `epsilon` represents the empty string. You can assume that all `NFAs` are well-formed and no list contains duplicate entries. The following examples assume that `M` is bound to the following NFA, which accepts the set of all strings over `[a,b]` ending in `a`.

```
nfa([0,1,2,3],[a,b],[(0,a,1),(0,b,1),(0,epsilon,1),(1,epsilon,0),(1,b,3),(1,a,2)],0,[2]),
```

Note that redundant choice points are acceptable, provided that no distinct solutions are obtained on backtracking. In particular, if there are multiple paths through an NFA on input `U` to a final state, then `accept/2` can report success for each path. Similarly, if there are multiple paths from a state `I` to a final state, then `productive/2` can succeed with redundant solutions for `I`. You can avoid duplicate solutions using cut or breadth-first search.

- **Predicate:** `move(M,From,A,To)`
- **Description:** `M` can transition to state `To` from state `From` on symbol `A`.
- **Usage:** If `M` is an NFA, then `move(M,From,A,To)` succeeds with all solutions for `From`, `A` and `To`.

```
?- move(M,1,a,2).
true.

?- move(M,1,b,2).
false.

?- setof((I,A,J),move(M,I,A,J),Moves).
Moves = [(0, a, 1),  (0, b, 1),  (1, a, 2),  (1, b, 3)].
```

- **Predicate:** `e_closure(M,From,To)`
- **Description:** `To` is an element of the epsilon-closure of `From`.
- **Usage:** If `M` is an `NFA`, then `e_closure(M,From,To)` succeeds with all solutions for `From` and `To`.

```
?- e_closure(M,0,2).
false.

?- e_closure(M,0,1).
true.

?- setof(I-J,e_closure(M,I,J),Closure).
Closure = [0-0, 0-1, 1-0, 1-1, 2-2, 3-3].
```

- **Predicate:** `accept(M,String)`
- **Description:** `String` is accepted by `M`.
- **Usage:** If `M` is an NFA and `String` a string, then `accept(M,String)` succeeds if `M` accepts `String`.

```
?- accept(M,[]).
false.

?- accept(M,[a,a]).
true.

?- accept(M,[a,b]).
false.
```

- **Predicate:** `productive(M,State)`
- **Description:** There is a final state reachable from `State` in `M`.
- **Usage:** If `M` is an NFA, then `productive(M,State)` succeeds with all solutions for `State`.

```
?- productive(M,3).
false.

?- productive(M,0).
true.

?- nfa:nfa_suffix(M), setof(I,productive(M,I),Productive).
Productive = [0, 1, 2].
```

- **Predicate:** `enumerate(M,Len,String)`
- **Description:** `String` is a string of length `Len` accepted by the NFA.
- **Usage:** If `M` is an NFA, then `enumerate(M,Len,String)` succeeds with all solutions for `Len` and `String`.

```
?- enumerate(M,0,U).
false.

?- setof(U,enumerate(M,2,U),Strings).
Strings = [[a, a], [b, a]].

?- setof(U,enumerate(M,3,U),Strings).
Strings = [[a, a, a], [a, b, a], [b, a, a], [b, b, a]].
```

Project Submission and Grading
------------------
Be sure to follow the project description exactly! Your solution will be graded automatically, so any deviation from the specification will result in lost points.

You can submit your project in two ways:
- Submit your files directly to the [submit server][submit server] as a zip file by clicking on the submit link in the column "web submission".  
![Where to find the web submission link][web submit link]  
Then, use the submit dialog to submit your zip file containing all of your source files directly.
![Where to upload the file][web upload example]  
Select your file using the "Browse" button, then press the "Submit project!" button. You will need to put it in a zip file since there are several component files. We provide a script `pack_submission.sh` which you can run to make a zip file containing all of the necessary files.
- Submit directly by executing a the submission script on a computer with Java and network access. Included in this project are the submission scripts and related files listed under **Project Files**. These files should be in the directory containing your project. From there you can either execute submit.rb or run the command `java -jar submit.jar` directly (this is all submit.rb does).

No matter how you choose to submit your project, make sure that your submission is received by checking the [submit server][submit server] after submitting.

Academic Integrity
------------------
Please **carefully read** the academic honesty section of the course syllabus. **Any evidence** of impermissible cooperation on projects, use of disallowed materials or resources, or unauthorized use of computer accounts, **will be** submitted to the Student Honor Council, which could result in an XF for the course, or suspension or expulsion from the University. Be sure you understand what you are and what you are not permitted to do in regards to academic integrity when it comes to project assignments. These policies apply to all students, and the Student Honor Council does not consider lack of knowledge of the policies to be a defense for violating them. Full information is found in the course syllabus, which you should review before starting.

[git instructions]: ../git_cheatsheet.md
[submit server]: submit.cs.umd.edu
[web submit link]: ../common-images/web_submit.jpg
[web upload example]: ../common-images/web_upload.jpg
