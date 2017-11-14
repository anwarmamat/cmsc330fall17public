:- module(lexer,[
       tokenize/2,
       tokenize_from_file/2
   ]).

:- use_module(library(pio)).
:- use_module(library(dcg/basics)).

tokenize(String,Tokens) :-
    string_to_list(String,Codes),
    phrase(tokens(Tokens),Codes).

tokenize_from_file(File,Tokens) :-
    phrase_from_file(tokens(Tokens),File).

tokens([])    --> blanks.
tokens([T|R]) --> blanks, token(T), tokens(R).

keyword(K) :- member(K,[int,bool,true,false,if,else,while]).
    
token(lparen)    --> "(".
token(rparen)    --> ")".
token(lbrace)    --> "{".
token(rbrace)    --> "}".
token(semicolon) --> ";".
token(eq)        --> "==".
token(plus)      --> "+".
token(mult)      --> "*".
token(or)        --> "||".
token(not)       --> "!".
token(lt)        --> "<".
token(assign)    --> "=", \+ "=".

token(int(N))  --> \+ "+", integer(N).
token(key(K))  --> codes(lower,S), {atom_codes(K,S), keyword(K)}.
token(id(X))   --> [C], {code_type(C,alpha)}, codes(alnum,R), {atom_codes(X,[C|R]), \+ keyword(X)}.

codes(K,[C|R])   --> [C], {code_type(C,K)}, codes(K,R).
codes(K,[]), [C] --> [C], {\+ code_type(C,K)}.
codes(_,[])      --> eos.
