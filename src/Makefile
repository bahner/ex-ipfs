#!/usr/bin/make -ef

default: clean all

clean:
	rm -f lexer.dot lexer.erl parser.erl

lexer.erl:
	./compile.escript lexer

parser.erl:
	./compile.escript parser

all:
	./compile.escript all

.PHONY: clean default
