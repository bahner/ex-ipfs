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

docker:
	mkdir -p .docker/ipfs_staging .docker_data/ipfs_data
	docker-compose up -d

format:
	mix format

docs: compile
	mix docs
	xdg-open doc/index.html

push: format commited compile
	git pull
	git push

commited:
	./.check.uncommited

parser:
	make -C src

.PHONY: compile docs docker
