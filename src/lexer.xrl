%% NB! This file is substantially overloaded with tokens, that
%% probably aren't needed. This is because I'm not sure what
%% tokens are needed, and what aren't. I'll clean this up later.
Definitions.

ALNUM 				 = [a-zA-Z0-9/]


%% tokens
IDENTIFIER      = ({ALNUM})+?

%% special characters and singletons
COMMA           = \,
COLON           = \:
SEMICOLON       = \;
FNUTT           = ["]
%% " The comment here is because of a bug in my editor.
ENKEL_FNUTT     = [']
%% ' The comment here is because of a bug in my editor.
SLASH           = \\

%% terminals and start states
RIGHT_BRACKET   = \]
RIGHT_BRACE     = \}
RIGHT_PAREN     = \)

%% begin
LEFT_BRACKET    = \[
LEFT_BRACE      = \{
LEFT_PAREN      = \(

%% whitespace
WHITESPACE      = [\s\n\r\t]+

Rules.

%% tokens
{IDENTIFIER}    : {token, {identifier,      TokenLine, erlang:list_to_binary(TokenChars)}}.

%% special characters and singletons

{COLON}         : {token, {colon,           TokenLine, ':'}}.
{COMMA}         : {token, {comma,           TokenLine, ','}}.
{SEMICOLON}     : {token, {semicolon,       TokenLine, ';'}}.
{FNUTT}         : {token, {fnutt,           TokenLine, '"'}}.
{ENKEL_FNUTT}   : {token, {enkel_fnutt,     TokenLine, "'"}}.

%% terminals and start states
{RIGHT_BRACKET} : {token, {right_bracket,   TokenLine, ']'}}.
{RIGHT_BRACE}   : {token, {right_brace,     TokenLine, '}'}}.
{RIGHT_PAREN}   : {token, {right_paren,     TokenLine, ')'}}.

%% begin
{LEFT_BRACKET}  : {token, {left_bracket,    TokenLine, '['}}.
{LEFT_BRACE}    : {token, {left_brace,      TokenLine, '{'}}.
{LEFT_PAREN}    : {token, {left_paren,      TokenLine, '('}}.

%% newlines
{LINEFEED}+      : skip_token.
{WHITESPACE}+    : skip_token.

%% comments

Erlang code.
