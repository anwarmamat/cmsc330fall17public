:- module(opsem,[
       typecheck_expr/3,
       typecheck_stmt/2,
       eval_expr/3,
       eval_stmt/3,
       interpret_expr/5,
       interpret_stmt/4
   ]).

:- use_module(parser).

% Predicate: interpret_expr(String,TypeEnv,Env,Type,Value)
% Description: String parses to an expression Expr with type Type in typing environment TypeEnv, and TypeEnv is consistent with environment Env, and Expr evalutes to value Value in Env.
% Notes: Typing environments are lists with elements of the form X-T, where X is an atom and T a type. Environments are lists with elements of the form X-V, where X is an atom and V a value.
% Usage: If String parses to expression Expr, and Expr is well-typed in typing environment TypeEnv, and TypeEnv is consistent with Env, then interpret_expr(String,TypeEnv,Env,Type,Value) succeeds with one solution for Type and Value.

interpret_expr(String,TypeEnv,Env,Type,Value) :-
    parse_expr(String,Expr),
    consistent_env(TypeEnv,Env),
    typecheck_expr(TypeEnv,Expr,Type),
    eval_expr(Env,Expr,Value).

% Predicate: interpret_stmt(String,TypeEnv,InitEnv,NewEnv)
% Description: String parses to a statement Stmt, and Stmt is well-typed in typing environment TypeEnv, and TypeEnv is consistent with environment InitEnv, and the result of evaluating Stmt in InitEnv is NewEnv.
% Notes: Typing environments are lists with elements of the form X-T, where X is an atom and T a type. Environments are lists with elements of the form X-V, where X is an atom and V a value.
% Usage: If String parses to statement Stmt, and Stmt is well-typed in typing environment TypeEnv, and TypeEnv is consistent with InitEnv, then interpret_stmt(String,TypeEnv,InitEnv,NewEnv) succeeds with one solution for NewEnv.

interpret_stmt(String,TypeEnv,InitEnv,NewEnv) :-
    parse_stmt(String,Stmt),
    consistent_env(TypeEnv,InitEnv),
    typecheck_stmt(TypeEnv,Stmt),
    eval_stmt(InitEnv,Stmt,NewEnv).

% Predicate: check_value(Type,Value)
% Description: Value has type Type.
% Usage: If Value is a value, then check_value(Type,Value) succeeds with one solution for Type.

check_value(int,N) :-
    integer(N).
check_value(bool,B) :-
    member(B,[true,false]).

% Predicate: consistent_envs(TypeEnv,Env)
% Description: TypeEnv and Env are consistent.
% Notes: Env is consistent with TypeEnv iff every variable in Env is well-typed with respect to TypeEnv.
% Usage: If TypeEnv and Env are consistent, then consistent_envs(TypeEnv,Env) succeeds.

consistent_env(TypeEnv,Env) :-
    forall(member(X-V,Env),(
        member(X-T,TypeEnv),
        check_value(T,V)
    )).

% Predicate: lookup(Env,K,V)
% Description: Env is an association list and K-V is the leftmost binding for K in Env.
% Usage: If V is the leftmost binding for K in in Env, then lookup(Env,K,V) succeeds with one solution for V.

lookup([K-V|_],K,V) :-
    !.
lookup([_|Rest],K,V) :-
    lookup(Rest,K,V).

% Predicate: typecheck_expr(Env,Expr,Type)
% Description: Expr has type Type in typing environment Env.
% Assumptions: Expr is a valid expression.
% Usage: If Env is a typing environment and Expr an expression, then typecheck_expr(Env,Expr,Type) succeeds with one solution for Type iff Expr is type correct in environment Env.

typecheck_expr(_,int(N),int) :-
    check_value(int,N).
typecheck_expr(_,bool(B),bool) :-
    check_value(bool,B).
typecheck_expr(Env,id(X),T) :-
    lookup(Env,X,T).

typecheck_expr(Env,eq(E1,E2),bool) :-
    typecheck_expr(Env,E1,T),
    typecheck_expr(Env,E2,T).

typecheck_expr(Env,lt(E1,E2),bool) :-
    typecheck_expr(Env,E1,int),
    typecheck_expr(Env,E2,int).

typecheck_expr(Env,not(E),bool) :-
    typecheck_expr(Env,E,bool).

typecheck_expr(Env,or(E1,E2),bool) :-
    typecheck_expr(Env,E1,bool),
    typecheck_expr(Env,E2,bool).

typecheck_expr(Env,plus(E1,E2),int) :-
    typecheck_expr(Env,E1,int),
    typecheck_expr(Env,E2,int).

typecheck_expr(Env,mult(E1,E2),int) :-
    typecheck_expr(Env,E1,int),
    typecheck_expr(Env,E2,int).

% Predicate: typecheck_stmt(Env,Stmt)
% Description: Stmt is type correct in typing environment Env.
% Assumptions: Stmt is a valid statement.
% Usage: If Env is a typing environment and Stmt a statement, then typecheck_stmt(Env,Stmt) succeed iff Stmt is type correct in environment Env.

typecheck_stmt(Env,Stmt) :-
    typecheck_stmt(Env,Stmt,_).

typecheck_stmt(Env,skip,Env).

typecheck_stmt(Env1,seq(S1,S2),Env3) :-
    typecheck_stmt(Env1,S1,Env2),
    typecheck_stmt(Env2,S2,Env3).

typecheck_stmt(Env,decl(T,X),[X-T|Env]) :-
    \+ lookup(Env,X,_).

typecheck_stmt(Env,assign(X,E),Env) :-
    lookup(Env,X,T),
    typecheck_expr(Env,E,T).

typecheck_stmt(Env1,while(G,B),Env2) :-
    typecheck_expr(Env1,G,bool),
    typecheck_stmt(Env1,B,Env2).

typecheck_stmt(Env1,cond(G,T,E),Env3) :-
    typecheck_expr(Env1,G,bool),
    typecheck_stmt(Env1,T,Env2),
    typecheck_stmt(Env2,E,Env3).

% Predicate: eval_expr(Env,Expr,Value)
% Description: Expr evaluates to value Value in environment Env.
% Assumptions: Expr is well-typed with respect to every variable in Env.
% Usage: If Expr is well-typed with respect to every variable in Env, then eval_expr(Env,Expr,Value) succeeds with one solution for Value.

eval_expr(Env,Expr,Value) :-
    fail.

% Predicate: eval_stmt(+Env,+Stmt,-NewEnv) is det
% Description: NewEnv is the result of evaluating Stmt in environment Env
% Assumptions: Stmt is well-typed with respect to every variable in Env.
% Usage: If Stmt is well-typed with respect to every variable in Env, then eval_stmt(Env,Stmt,NewEnv) succeeds with one solution for NewEnv.

eval_stmt(Env,Stmt,NewEnv) :-
    fail.
