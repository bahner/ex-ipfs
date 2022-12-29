%% NB! This file is substantially overloaded with tokens, that
%% probably aren't needed. This is because I'm not sure what
%% tokens are needed, and what aren't. I'll clean this up later.
Definitions.

% Keys are camelcased strings, and values are strings.
KEY				= [A-Z][A-Za-z]*
VALUE      = ([^"\n]|\\(.|\n))*
% " The comment here is because of a bug in my editor.

%% special characters and singletons
COMMA           = \,
COLON           = \:
SEMICOLON       = \;
DOUBLE_QUOTE    = ["]
%% " The comment here is because of a bug in my editor.
QUOTE     			= \'
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
WHITESPACE      = [\s\t]
NEWLINE				 	= \n

%% tokens
%% " The comment here is because of a bug in my editor.
Rules.

{COLON}         : {token, {':',			TokenLine}}.
{COMMA}         : {token, {',',			TokenLine}}.
{SEMICOLON}     : {token, {';',			TokenLine}}.
{QUOTE}   			: {token, {'\'',		TokenLine}}.

{RIGHT_BRACKET} : {token, {']',			TokenLine}}.
{RIGHT_BRACE}   : {token, {'}',			TokenLine}}.
{RIGHT_PAREN}   : {token, {')',			TokenLine}}.
{LEFT_BRACKET}  : {token, {'[',			TokenLine}}.
{LEFT_BRACE}    : {token, {'{',			TokenLine}}.
{LEFT_PAREN}    : {token, {'(',			TokenLine}}.

{NEWLINE}       : {token, {newline,	TokenLine}}.

{DOUBLE_QUOTE}   : skip_token.

%% VALUE is so greedy, that it *MUST* be last.
{KEY}    				: {token, {key,			TokenLine, erlang:list_to_binary(TokenChars)}}.
{VALUE}    			: {token, {value,		TokenLine, erlang:list_to_binary(TokenChars)}}.
%% comments

Erlang code.
