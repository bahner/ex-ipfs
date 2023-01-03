# IPFS RPC API client for Elixir

![](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)

## This library is still a work in progress

The reason for starting a new IPFS module is that none of the others seem to work at all.

All commands added, but *not* verified. For your everyday IPFS oiperations the moduile should work by now. But no guarantees. :-) Please, please, please - file issues and feature requests.

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
```

The basic commands are in the MyspaceIPFS module. The grouped ipfs commands each have their separate module, eg. MyspaceIPFS.Refs, MyspaceIPFS.Blocks etc.