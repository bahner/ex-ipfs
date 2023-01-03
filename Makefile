#!/usr/bin/make -ef

VERSION ?= $(shell cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/')


tag:
	git tag $(VERSION)

release: tag
	mix hex.publish
	git push --tags

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
