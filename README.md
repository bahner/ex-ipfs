# Ipfs Api wrapper library for Elixir

![](https://ipfs.io/ipfs/QmQJ68PFMDdAsgCZvA1UVzzn18asVcf7HVvCDgpjiSCAse)


## This library is still a work in progress

The reason for starting a new IPFS module is that none of the others seem to work at all.

Thus far 85% of the functionality has been implmented in this particular API.  Most of the funcitons do not support adding in the optional arguments just yet.  Once I've implmented all of the commands I will work on adding the optional flags into each function. 

It is based on elixir_ipfs. I kept the git logs as acknowledgement, but it is not compatible in any way shape or form anymore. It is done to supply my myspace project with a working IPFS implentation. This seems smarter than writing something directly in that repo.

For simple operations it should work just fine. As of writing I suspect I will have a version 1.0.0 in a few days. I intend to keep it up2date with IPFS. I welcome participation in making that happen, once I get commands stable.

# Install

Add myspace_ipfs to your `mix.exs` dependencies:
```elixir
def deps do
[
    {:myspace_ipfs, "~> 0.0.1"},
]
end
```

and run `$ mix deps.get` to install the dependency.  

## Usage
Make sure ipfs is running. Then you can start using the module. Documentation is picking up. And should be fairly decent, when I reach 1.0.0.
