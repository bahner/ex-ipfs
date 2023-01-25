# IPFS RPC API client for Elixir

![](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)

## This library is still a work in progress

The reason for starting a new IPFS module is that none of the others seem to work at all.

All commands added, but *not* verified. For your everyday IPFS operations the module should work by now. But no guarantees. :-) Please, please, please - file issues and feature requests.

Version 0.1.0 is substantially better than version 0.0.1 and not compatible at all.

## Install

Add myspace_ipfs to your `mix.exs` dependencies:
```elixir
def deps do
[
    {:myspace_ipfs, "~> 0.1.0"},
]
end
```

and run `$ mix deps.get` to install the dependency.

## Configuration

The default should brobably be OK, but you may override the default with the environment variables.

These are the defaults.
```
export MYSPACE_IPFS_API_URL="http://127.0.0.1:5001"
export MYSPACE_IPFS_DEBUG="true"
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

The basic commands are in the MyspaceIPFS module. The grouped ipfs commands each have their separate module, eg. MyspaceIPFS.Refs, MyspaceIPFS.Blocks etc.
