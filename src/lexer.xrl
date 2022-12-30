%%% File    : erlang_scan.xrl
%%% Author  : Robert Virding
%%% Purpose : Token definitions for Erlang.

Definitions.
U	= [A-Z]
L	= [a-z]
A	= ({U}|{L}|{D}|_|@)
WS	= ([\000-\s]|%.*)

Rules.
'(\\\^.|\\.|[^'])*' :
			%% Strip quotes.
			S = lists:sublist(TokenChars, 2, TokenLen - 2),
			case catch list_to_atom(string_gen(S)) of
			    {'EXIT',_} -> {error,"illegal atom " ++ TokenChars};
			    Atom -> {token,{atom,TokenLine,Atom}}
			end.
"(\\\^.|\\.|[^"])*" :
			%% Strip quotes.
			S = lists:sublist(TokenChars, 2, TokenLen - 2),
			{token,{string,TokenLine,string_gen(S)}}.
\$(\\{O}{O}{O}|\\\^.|\\.|.) :
			{token,{char,TokenLine,cc_convert(TokenChars)}}.
[][}{;:,] :
			{token,{list_to_atom(TokenChars),TokenLine}}.
\.{WS}		:	{end_token,{dot,TokenLine}}.
{WS}+		:	skip_token.

Erlang code.

cc_convert([$$,$\\|Cs]) ->
    hd(string_escape(Cs));
cc_convert([$$,C]) -> C.

string_gen([$\\|Cs]) ->
    string_escape(Cs);
string_gen([C|Cs]) ->
    [C|string_gen(Cs)];
string_gen([]) -> [].

string_escape([O1,O2,O3|S]) when
  O1 >= $0, O1 =< $7, O2 >= $0, O2 =< $7, O3 >= $0, O3 =< $7 ->
    [(O1*8 + O2)*8 + O3 - 73*$0|string_gen(S)];
string_escape([$^,C|Cs]) ->
    [C band 31|string_gen(Cs)];
string_escape([C|Cs]) when C >= $\000, C =< $\s ->
    string_gen(Cs);
string_escape([C|Cs]) ->
    [escape_char(C)|string_gen(Cs)].

escape_char($n) -> $\n;				%\n = LF
escape_char($r) -> $\r;				%\r = CR
escape_char($t) -> $\t;				%\t = TAB
escape_char($v) -> $\v;				%\v = VT
escape_char($b) -> $\b;				%\b = BS
escape_char($f) -> $\f;				%\f = FF
escape_char($e) -> $\e;				%\e = ESC
escape_char($s) -> $\s;				%\s = SPC
escape_char($d) -> $\d;				%\d = DEL
escape_char(C) -> C.
