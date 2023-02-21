#!/usr/bin/make -ef

VERSION ?= $(shell cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/')

# Exporting the config values allows us to generate Dockerfile and github config using envsubst.
export KUBO_VERSION ?= v0.18.1
export DOCKER_USER ?= bahner
export DOCKER_IMAGE ?= $(DOCKER_USER)/kubo:$(KUBO_VERSION)

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

cover:
	mix coveralls.html
	xdg-open cover/excoveralls.html

image: templates
	docker build -t $(DOCKER_IMAGE) --no-cache .

format:
	mix format

mix: all
	iex -S mix

proper: distclean compile test

push: all commited test
	git pull
	git push

publish-image: image
	docker push $(DOCKER_IMAGE)

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
	rm -rf cover

.PHONY: compile docs docker test templates cover
