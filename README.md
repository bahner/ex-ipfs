# IPFS RPC API client for Elixir
ooo

![IPFS logo](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)

[![Unit and integration tests](https://github.com/bahner/ex-ipfs/actions/workflows/testsuite.yaml/badge.svg)](https://github.com/bahner/ex-ipfs/actions/workflows/testsuite.yaml)
[![Coverage Status](https://coveralls.io/repos/github/bahner/ex-ipfs/badge.svg)](https://coveralls.io/github/bahner/ex-ipfs)

Core IPFS module for Elixir. This is the main package with the Api handler and most common types and structs. It suffices to for working with IPFS data as files, but IPLD will be a separate package.

If you are unfamiliar with how IPFS works, it uses a daemon that has a RPC API exposed on localhost:5001. Working with IPFS is then done by interacting with the API. Some commands are executed and interpreted directly on the command line by the daemon. One such function is `key export`. But that is not a problem in practicality. (Key handling is part of the [ex_ipfs_ipns](https://hex.pm/packages/ex_ipfs_ipns) package.) This modules acts as a hybrid of those. The intention is to make it easy to work with IPFS in your Elixir applications.

Feature requests are welcome. Features present in this module are:

* API requests and error handling
* CID conversions
* Multibase formatting
* Multibase codecs and encodings
* Ping swarm peers
* Publishing and retreiving immutable data as files in IPFS

More modules are under way. The following are implemented:

* [IPLD](https://hex.pm/packages/ex_ipfs_ipld)
* [IPNS](https://hex.pm/packages/ex_ipfs_ipns)

## Requirements

Only OTP 25 and newer are supported due to an underlying issue with SSL Certificate handling.

## Configuration

The default should be OK, but you may override the API with the following environment variables.

```bash
export EX_IPFS_API_URL="http://127.0.0.1:5001"
```

### Logger

ExIpfs uses Logger and is quite noisy when you are developing. If you set your log level below `debug` you should be OK.

## Documentation

The documentation is a little unbalanced. I am feeling my way forward as to how much I should document here. Each command will receive a link to the official documentation at least.

## Usage

Make sure ipfs is running. This module does not provide handling of the IPFS daemon, but it does provide a docker container that matches the API.

To use do:

```elixir
iex(1)> ExIpfs.cat("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
"Hello World!\r\n"
iex(2)>

```

### Docker

Install docker-compose and run

```bash
make image
docker-compose up
```

See below for how to build special versions. This docker enables the experimental features. Otherwise you can use any IPFS installation.

## Development

If you want to update the IPFS version and create your own docker image to be used for testing, then export the following environment variables.

```bash
export KUBO_VERSION=0.17.0
export DOCKER_USER=bahner
export DOCKER_IMAGE=${DOCKER_USER}/kubo:${KUBO_VERSION}
make publish-image
```

so a shorthand would be:

```bash
KUBO_VERSION=v0.19.0rc2 DOCKER_USER=yourdockeraccount make publish-image # The simplest.
# or
KUBO_VERSION=0.17.0 DOCKER_IMAGE=http://my.local.registry:5000/testing-buils/ipfs:testlabl make publish-image
```
