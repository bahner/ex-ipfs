#!/usr/bin/make -ef

VERSION ?= $(shell cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/')

# Exporting the config values allows us to generate Dockerfile and github config using envsubst.
export KUBO_VERSION ?= v0.17.0
export DOCKER_IMAGE ?= bahner/kubo:$(KUBO_VERSION)

all: deps format compile

commited: templates
	./.check.uncommited

compile: deps
	mix compile

deps:
	mix deps.get

dialyzer:
	mix dialyzer

docker:
	mkdir -p .docker/ipfs_staging .docker_data/ipfs_data
	docker-compose up -d

docs:
	mix docs
	xdg-open doc/index.html

image:
	docker build -t bahner/kubo:$(KUBO_VERSION) --no-cache .

format:
	mix format

mix: all
	iex -S mix

proper: distclean compile test

push: all commited test
	git pull
	git push

release: tag
	mix hex.publish
	git push --tags

tag:
	git tag $(VERSION)

templates:
	envsubst < templates/Dockerfile > Dockerfile
	envsubst < templates/testsuite.yaml > .github/workflows/testsuite.yaml

test: dialyzer
	mix test

distclean: clean
	rm -rf _build deps mix.lock

clean:
	rm -f Qm*

.PHONY: compile docs docker test templates
