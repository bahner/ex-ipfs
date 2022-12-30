#!/usr/bin/env escript
%% -*- erlang -*-
%%! -escript main main/1
main([Target]) ->
  case Target of
    "parser" -> yecc:file('parser.yrl');
    "lexer" -> leex:file('lexer.xrl');
    "all" ->
      leex:file('lexer.xrl'),
      yecc:file('parser.yrl')
  end,
  halt(0).
