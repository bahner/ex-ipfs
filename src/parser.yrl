Nonterminals list elems elem key_elem.
Terminals '{' '}' ',' '[' ']' key.
Rootsymbol list.

grammar list.
list -> '[' ']'       : %{}.
list -> '{' elems '}' : '$2'.

key_elem ->  elem elem       : {'$1', '$2'}.
elems -> elem                : ['$1'].
elems -> key_elem            : ['$1'].
elems -> key_elem ',' elems  : ['$1'|'$3'].
elems -> elem ',' elems      : ['$1'|'$3'].

elem -> key :  'Elixir.Helpers':extract_token('$1').

elem -> list : '$1'.

% Erlang code.
