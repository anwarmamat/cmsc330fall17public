exception TypeError of string
exception DeclarationError of string
exception DivByZeroError

val eval_expr : Types.environment -> Types.expr -> Types.value
val eval_stmt : Types.environment -> Types.stmt -> Types.environment
