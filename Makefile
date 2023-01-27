#!/usr/bin/make -ef

VERSION ?= $(shell cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/')

all: deps format compile
	mix format
	mix compile

mix: all
	iex -S mix

push: all commited test
	git push

tag:
	git tag $(VERSION)

release: tag
	mix hex.publish
	git push --tags

compile: format
	mix compile

deps:
	mix deps.get

docker:
	mkdir -p .docker/ipfs_staging .docker_data/ipfs_data
	docker-compose up -d

format:
	mix format

docs: compile
	mix docs
	xdg-open doc/index.html

push: format commited
	git pull
	git push

test:
	mix test

commited:
	./.check.uncommited

clean:
	rm -rf _build deps mix.lock
	rm -f Qm*

.PHONY: compile docs docker test
