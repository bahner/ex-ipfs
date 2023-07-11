#!/usr/bin/make -ef

VERSION ?= $(shell cat mix.exs | grep version | sed -e 's/.*version: "\(.*\)",/\1/')

# Exporting the config values allows us to generate Dockerfile and github config using envsubst.
export KUBO_VERSION ?= v0.21.0
export DOCKER_USER ?= ipfs
export DOCKER_IMAGE ?= $(DOCKER_USER)/kubo:$(KUBO_VERSION)

all: deps format compile test

commited: templates
	./.check.uncommited

compile:
	mix compile

deps:
	mix deps.get

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

map:
	mix xref graph --format dot
	dot -Tpng xref_graph.dot -o xref_graph.png
	eog xref_graph.png

mix: all
	iex -S mix

proper: distclean compile test

push: all commited test
	git pull
	git push

publish-image: image
	docker push $(DOCKER_IMAGE)

release: test
	git tag $(VERSION)
	mix hex.publish
	git push --tags

templates:
	envsubst < templates/Dockerfile > Dockerfile
	envsubst < templates/testsuite.yaml > .github/workflows/testsuite.yaml

test:
	mix format --check-formatted
	mix credo
	mix dialyzer
	mix test

distclean: clean
	rm -rf _build deps mix.lock

clean:
	rm -f Qm*
	rm -rf cover
	rm -f xref_*

.PHONY: compile docs docker test templates cover
