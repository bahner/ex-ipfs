# Ipfs Api wrapper library for Elixir

![](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)


## This library is still a work in progress

The reason for starting a new IPFS module is that none of the others seem to work at all.

Thus far 85% of the functionality has been implmented in this particular API.  Most of the funcitons do not support adding in the optional arguments just yet.  Once I've implmented all of the commands I will work on adding the optional flags into each function. 

For simple operations it should work just fine. As of writing I suspect I will have usable version in a few days. I welcome participation in making that happen, once I get commands stable.

## Install

Add myspace_ipfs to your `mix.exs` dependencies:
```elixir
def deps do
[
    {:myspace_ipfs, "~> 1.0.0"},
]
end
```

and run `$ mix deps.get` to install the dependency.  

## Documentation
The documentation is very unbalanced. I am feeling my way forward as to how much I should document here. Each command will receive a link to the official documentation at least.

## Usage
Make sure ipfs is running. Then you can start using the module.

To use do:
```elixir
alias MyspaceIPFS, as: IPFS
IPFS.id()

MyspaceIPFS.Refs.refs("/ipns/myspace.bahner.com")

alias MyspaceIPFS.Refs
Refs.local()
```

The basic commands are in the MyspaceIPFS module. The grouped ipds commands each have their separate module, eg. MyspaceIPFS.Refs, MyspaceIPFS.Blocks etc.
