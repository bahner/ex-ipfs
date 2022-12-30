#!/usr/bin/make -ef

default: compile docs

compile: format parser
	mix compile

format:
	mix format

docs: compile
	mix docs
	xdg-open doc/index.html

parser:
	make -C src

.PHONY: compile docs
