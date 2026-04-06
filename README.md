# IPFS RPC API client for Elixir

![IPFS logo](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)

[![Unit and integration tests](https://github.com/bahner/ex-ipfs/actions/workflows/testsuite.yaml/badge.svg)](https://github.com/bahner/ex-ipfs/actions/workflows/testsuite.yaml)
[![Coverage Status](https://coveralls.io/repos/github/bahner/ex-ipfs/badge.svg)](https://coveralls.io/github/bahner/ex-ipfs)

Core IPFS module for Elixir. This is the main package with the API handler and most common types and structs. It is sufficient for working with IPFS data as files, while IPLD is provided as a separate package.

If you are unfamiliar with how IPFS works, it uses a daemon that exposes an RPC API on localhost:5001. Working with IPFS is done by interacting with that API. Some commands are still CLI-first on the daemon side (for example `key export`), but that is not a practical limitation for this package. (Key handling is part of the [ex_ipfs_ipns](https://hex.pm/packages/ex_ipfs_ipns) package.) This module acts as a convenient API wrapper to make IPFS workflows easy to integrate in Elixir applications.

Feature requests are welcome. Features present in this module are:

* API requests and error handling
* CID conversions
* Multibase formatting
* Multibase codecs and encodings
* Ping swarm peers
* Publishing and retrieving immutable data as files in IPFS

More modules are under way. The following are implemented:

* [IPLD](https://hex.pm/packages/ex_ipfs_ipld)
* [IPNS](https://hex.pm/packages/ex_ipfs_ipns)

## Requirements

Minimum requirements:

* Elixir `~> 1.18` (see `mix.exs`)
* Erlang/OTP `>= 25`
* A running Kubo daemon with RPC API available (default: `http://127.0.0.1:5001/api/v0`)

Optional (for local daemon/testing):

* Docker with access to the Docker daemon
* Kubo image example: `ipfs/kubo:v0.40.1`

Tested example environment:

* Elixir `1.19.x`
* OTP `27/28`
* Kubo `0.40.1`

## Configuration

The default should be OK, but you may override the API with the following environment variables.

```bash
export EX_IPFS_API_URL="http://127.0.0.1:5001/api/v0"
```

### Logger

ExIpfs uses Logger and is quite noisy when you are developing. If you set your log level below `debug` you should be OK.

## Documentation

The documentation is a little unbalanced. I am feeling my way forward as to how much I should document here. Each command will receive a link to the official documentation at least.

## Usage

Make sure Kubo (IPFS daemon) is running. This module does not manage the daemon itself.
Any reasonably recent Kubo version should work; examples below use `v0.40.1`.

To use do:

```elixir
iex(1)> ExIpfs.cat("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
"Hello World!\r\n"
iex(2)>

```

### Docker

If you want a local daemon quickly, you can run Docker.

```bash
DOCKER_IMAGE=ipfs/kubo:v0.40.1 docker compose up -d
```

You can also use the repository image/build tooling below. In practice, you may use any Kubo setup you prefer.

## Development

If you want to build and publish your own Kubo image for testing, set these variables:

```bash
export KUBO_VERSION=v0.40.1
export DOCKER_USER=bahner
export DOCKER_IMAGE=${DOCKER_USER}/kubo:${KUBO_VERSION}
make publish-image
```

Shorthand examples:

```bash
KUBO_VERSION=v0.40.1 DOCKER_USER=yourdockeraccount make publish-image
# or
KUBO_VERSION=v0.40.1 DOCKER_IMAGE=my.local.registry:5000/testing-builds/ipfs:v0.40.1 make publish-image
```
