# IPFS RPC API client for Elixir

![](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)

[![Unit and integration tests](https://github.com/bahner/ex-ipfs/actions/workflows/testsuite.yaml/badge.svg)](https://github.com/bahner/ex-ipfs/actions/workflows/testsuite.yaml)
[![Coverage Status](https://coveralls.io/repos/github/bahner/ex-ipfs/badge.svg?branch=develop)](https://coveralls.io/github/bahner/ex-ipfs?branch=develop)

## This library is still a work in progress

Core IPFS module for Elixir. This is the main package with the Api handler and most common types and structs. It suffices to for working with IPFS data as files, but IPLD will be a separate package.

## Install

Add ex_ipfs to your `mix.exs` dependencies:
```elixir
def deps do
[
    {:ex_ipfs, "~> 0.0.1"},
]
end
```

and run `make mix` to install the dependencies.

## Configuration

The default should brobably be OK, but you may override the default with the environment variables.

```
export EX_IPFS_API_URL="http://127.0.0.1:5001"
```

## Documentation
The documentation is a little unbalanced. I am feeling my way forward as to how much I should document here. Each command will receive a link to the official documentation at least.

## Usage
Make sure ipfs is running. This module does not provide handling of the IPFS daemon, but it does provide a docker container that matches the API.

To use do:
```elixir
alias ExIpfs, as: IPFS
IPFS.id()

ExIpfs.Refs.refs("/ipns/ex.bahner.com")

alias ExIpfs.Refs
Refs.local()

```

### Docker
Install docker-compose and run
```
docker-compose up
```
See below for how to build special versions. This docker enables the experimental features. Otherwise you can use any IPFS installation.

## Development

If you want to update the IPFS version and create your own docker image to be used for testing, then export the following environment variables.
```
export KUBO_VERSION=0.17.0
export DOCKER_USER=bahner
export DOCKER_IMAGE=${DOCKER_USER}/kubo:${KUBO_VERSION}
make publish-image
```
so a shorthand would be:
```
KUBO_VERSION=v0.19.0rc2 DOCKER_USER=yourdockeraccount make publish-image # The simplest.
# or
KUBO_VERSION=0.17.0 DOCKER_IMAGE=http://my.local.registry:5000/testing-buils/ipfs:testlabl make publish-image
```

