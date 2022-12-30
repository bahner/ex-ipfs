%%% File    : erlang_scan.xrl, lexer.xrl
%%% Author  : Robert Virding, Lars Bahner
%%% Purpose : Token definitions for parsing non-JSON IPFS data.
% Copyright © 2022, Lars Bahner

Definitions.
O  = [0-7]
D  = [0-9]
H  = [0-9a-fA-F]
U  = [A-Z]
L  = [a-z]
A  = ({U}|{L}|{D}|_|@)
WS = ([\000-\s]|%.*)

Rules.
[\n]  : {token,{newline,TokenLine}}.
\{    : {token,{lbrace,TokenLine}}.
\}    : {token,{rbrace,TokenLine}}.
\[    : {token,{lbracket,TokenLine}}.
\]    : {token,{rbracket,TokenLine}}.
\:    : {token,{colon,TokenLine}}.
\,    : {token,{comma,TokenLine}}.
""    : {token,{empty,TokenLine, ""}}.
\[\]  : {token,{empty,TokenLine,[]}}.
\{\}  : {token,{empty,TokenLine,{}}}.
false : {token,{boolean,TokenLine,false}}.
true  : {token,{boolean,TokenLine,true}}.
null  : {token,{null,TokenLine,nil}}.

{D}+\.{D}+((E|e)(\+|\-)?{D}+)? :
      {token,{float,TokenLine,list_to_float(TokenChars)}}.
{D}+#{H}+ : base(TokenLine, TokenChars).
{D}+    : {token,{integer,TokenLine,list_to_integer(TokenChars)}}.
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
\.{WS}    : {end_token,{dot,TokenLine}}.
{WS}+   : skip_token.

Erlang code.
base(L, Cs) ->
    H = string:chr(Cs, $#),
    case list_to_integer(string:substr(Cs, 1, H-1)) of
  B when B > 16 -> {error,"illegal base"};
  B ->
      case base(string:substr(Cs, H+1), B, 0) of
    error -> {error,"illegal based number"};
    N -> {token,{integer,L,N}}
      end
    end.

base([C|Cs], Base, SoFar) when C >= $0, C =< $9, C < Base + $0 ->
    Next = SoFar * Base + (C - $0),
    base(Cs, Base, Next);
base([C|Cs], Base, SoFar) when C >= $a, C =< $f, C < Base + $a - 10 ->
    Next = SoFar * Base + (C - $a + 10),
    base(Cs, Base, Next);
base([C|Cs], Base, SoFar) when C >= $A, C =< $F, C < Base + $A - 10 ->
    Next = SoFar * Base + (C - $A + 10),
    base(Cs, Base, Next);
base([_|_], _, _) -> error;     %Unknown character
base([], _, N) -> N.

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

escape_char($n) -> $\n;       %\n = LF
escape_char($r) -> $\r;       %\r = CR
escape_char($t) -> $\t;       %\t = TAB
escape_char($v) -> $\v;       %\v = VT
escape_char($b) -> $\b;       %\b = BS
escape_char($f) -> $\f;       %\f = FF
escape_char($e) -> $\e;       %\e = ESC
escape_char($s) -> $\s;       %\s = SPC
escape_char($d) -> $\d;       %\d = DEL
escape_char(C) -> C.
