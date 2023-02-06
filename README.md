# IPFS RPC API client for Elixir

![](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)

## This library is still a work in progress

The reason for starting a new IPFS module is that none of the others seem to work at all.

All commands added, but *not* verified. For your everyday IPFS operations the module should work by now. But no guarantees. :-) Please, please, please - file issues and feature requests.

Version 0.2.0 is substantially better than version 0.1.0. I consider it of beta-quality.

## Install

Add myspace_ipfs to your `mix.exs` dependencies:
```elixir
def deps do
[
    {:myspace_ipfs, "~> 0.2.0"},
]
end
```

and run `make mix` to install the dependencies.

## Configuration

The default should brobably be OK, but you may override the default with the environment variables.

```
export MYSPACE_IPFS_API_URL="http://127.0.0.1:5001"
```

## Documentation
The documentation is very unbalanced. I am feeling my way forward as to how much I should document here. Each command will receive a link to the official documentation at least.

## Usage
Make sure ipfs is running. Then you can start using the module. If ipfs isn't running, you may try `MyspaceIPFS.daemon()`.

To use do:
```elixir
alias MyspaceIPFS, as: IPFS
IPFS.id()

MyspaceIPFS.Refs.refs("/ipns/myspace.bahner.com")

alias MyspaceIPFS.Refs
Refs.local()

# Subscribe to a PubSub Channel and send the message to my inbox
MyspaceIPFS.PubSub.Channel.start_link(self(), "mychannel")
flush
```
Some commands, like channel and tail that streams data needs a pid to send messages to. 

The basic commands are in the MyspaceIPFS module. The grouped ipfs commands each have their separate module, eg. MyspaceIPFS.Refs, MyspaceIPFS.Blocks etc.

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
