Nonterminals key value list values tuple tuples object objects.
Terminals colon comma lbrace rbrace lbracket rbracket string integer empty newline boolean null.
Rootsymbol objects.

% TODO add lists and maps to values

% a list of objects
% objects are separated by newlines
objects -> object newline objects : ['$1'|'$3'].
objects -> object newline : ['$1'].
objects -> object : ['$1'].

% an object is a map of tuples
object -> lbrace tuples rbrace : '$2'.
% object -> lbrace rbrace : {}.

% a list of tuples
tuples -> tuple comma tuples : put_tuple('$1', '$3').
tuples -> tuple comma : put_tuple('$1').
tuples -> tuple : put_tuple('$1').
tuples -> lbrace rbrace : #{}.

% a tuple is a key value pair
tuple -> key value: {'$1', '$2'}.
tuple -> key: {'$1', nil}.

% the value is a string, an object, or empty
values -> value comma values : ['$1'|'$3'].
values -> value comma : ['$1'].
values -> value : ['$1'].

value -> string : extract_token('$1').
value -> integer : extract_token('$1').
value -> boolean : extract_token('$1').
% There are empty strings, empty maps, and empty lists
value -> empty : extract_token('$1').
value -> null : extract_token('$1').
value -> object : '$1'.
value -> list : '$1'.

list -> lbracket values rbracket : '$2'.
list -> lbracket rbracket : [].

% the key is a string followed by a colon
key -> string colon : extract_token('$1').

Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
put_tuple({Key, Value}) -> maps:put(Key, Value, #{}).
put_tuple({Key, Value}, Map) -> maps:merge(maps:put(Key, Value, #{}), Map).

