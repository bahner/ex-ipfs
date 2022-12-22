#!/usr/bin/make -ef

default: compile docs

compile: format
	mix compile

format:
	mix format

docs: compile
	mix docs
	xdg-open doc/index.html

.PHONY: compile docs
