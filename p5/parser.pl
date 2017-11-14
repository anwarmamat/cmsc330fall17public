:- module(parser,[
       parse_expr/2,
       parse_stmt/2,
       parse_stmt_from_file/2
   ]).

:- use_module(lexer).
:- use_module(library(pio)).
:- use_module(library(dcg/basics)).

parse_expr(String,Expr) :-
    tokenize(String,Tokens),
    phrase(expr(Expr),Tokens).

parse_stmt(String,Stmt) :-
    tokenize(String,Tokens),
    phrase(stmts(Stmt),Tokens).

parse_stmt_from_file(File,Stmt) :-
    tokenize_from_file(File,Tokens),
    phrase(stmts(Stmt),Tokens).

stmts(skip)     --> [].
stmts(seq(S,R)) --> stmt(S), stmts(R).

stmt(decl(T,X))   --> [key(T), id(X), semicolon], {memberchk(T,[int,bool])}.
stmt(assign(X,E)) --> [id(X), assign], expr(E), [semicolon].
stmt(cond(G,T,E)) --> [key(if), lparen], expr(G), [rparen, lbrace], stmts(T), [rbrace], else_branch(E).
stmt(while(G,B))  --> [key(while), lparen], expr(G), [rparen, lbrace], stmts(B), [rbrace].

else_branch(skip) --> [].
else_branch(S)    --> [key(else), lbrace], stmts(S), [rbrace].

expr(E)       --> eq_expr(E).
expr(or(L,R)) --> eq_expr(L), [or], expr(R).

eq_expr(E)       --> lt_expr(E).
eq_expr(eq(L,R)) --> lt_expr(L), [eq], eq_expr(R).

lt_expr(E)       --> not_expr(E).
lt_expr(lt(L,R)) --> not_expr(L), [lt], lt_expr(R).

not_expr(E)      --> plus_expr(E).
not_expr(not(E)) --> [not], not_expr(E).

plus_expr(E)         --> mult_expr(E).
plus_expr(plus(L,R)) --> mult_expr(L), [plus], plus_expr(R).

mult_expr(E)         --> prim_expr(E).
mult_expr(mult(L,R)) --> prim_expr(L), [mult], mult_expr(R).

prim_expr(E)       --> [lparen], expr(E), [rparen].
prim_expr(id(X))   --> [id(X)].
prim_expr(int(N))  --> [int(N)].
prim_expr(bool(B)) --> [key(B)], {memberchk(B,[true,false])}.
