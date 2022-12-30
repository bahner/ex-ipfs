Nonterminals tuple tuples objects object key value.
Terminals ':' ',' '{' '}' newline string.
Rootsymbol objects.

objects -> object newline objects : ['$1'|'$3'].
objects -> object newline : ['$1'].
objects -> object : ['$1'].

object -> '{' tuples '}': '$1'.
object -> '{' '}': [].

tuples -> tuple ',' tuples : ['$1'|'$3'].
tuples -> tuple ',' : ['$1'].
tuples -> tuple : ['$1'].

tuple -> key ':' value : {'$1', '$3'}.

value -> string : 'Elixir.Helpers':extract_token('$1').
value -> object : '$1'.

key -> string ':' : 'Elixir.Helpers':extract_token('$1').

% Erlang code.

