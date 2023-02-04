#!/usr/bin/make -ef

VERSION ?= $(shell cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/')

all: deps format compile
	mix format
	mix compile

commited:
	./.check.uncommited

compile: deps format
	mix compile

deps:
	mix deps.get

dialyzer:
	mix dialyzer

docker:
	mkdir -p .docker/ipfs_staging .docker_data/ipfs_data
	docker-compose up -d

docs: compile
	mix docs
	xdg-open doc/index.html

format:
	mix format

mix: all
	iex -S mix

proper: distclean compile test

push: format commited all
	git pull
	git push

release: tag
	mix hex.publish
	git push --tags

tag:
	git tag $(VERSION)

test: dialyzer
	mix test

distclean: clean
	rm -rf _build deps mix.lock

clean:
	rm -f Qm*

.PHONY: compile docs docker test
