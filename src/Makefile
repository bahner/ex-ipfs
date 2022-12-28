#!/usr/bin/make -ef

default: clean lexer.erl parser.erl

clean:
	rm -f lexer.dot lexer.erl parser.erl

lexer.erl:
	elixir lexer.exs

parser.erl:
	elixir parser.exs

.PHONY: clean default
