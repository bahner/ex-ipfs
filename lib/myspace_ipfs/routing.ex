defmodule MyspaceIpfs.Routing do
  @moduledoc """
  MyspaceIpfs.Routing is where the routing commands of the IPFS API reside.
  """

  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils

  @typep api_error :: MyspaceIpfs.Api.api_error()
  @typep peer_id :: MyspaceIpfs.peer_id()
  @typep opts :: MyspaceIpfs.opts()
  @typep name :: MyspaceIpfs.name()

  @doc """
  Find the multiaddresses associated with a peer ID.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-routing-findpeer
    verbose - <bool>, # Write extra information.
  """
  @spec findpeer(peer_id, opts) :: {:ok, any} | api_error()
  def findpeer(peer_id, opts \\ []) do
    post_query("/routing/findpeer?arg=#{peer_id}", query: opts)
    |> okify()
  end

  @doc """
  Find peers that can provide a specific value, given a key.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-routing-findprovs
    verbose - <bool>, # Write extra information.
    num-providers - <int>, # The number of providers to find.
  """
  @spec findprovs(peer_id, opts) :: {:ok, any} | api_error()
  def findprovs(cid, opts \\ []) do
    post_query("/routing/findprovs?arg=#{cid}", query: opts)
    |> okify()
  end

  @doc """
  Announce to the network that you are providing given values.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-routing-provide
    recursive - <bool>, # Recursively provide entire graph.
    verbose - <bool>, # Write extra information.
  """
  @spec provide(name, opts) :: {:ok, any} | api_error()
  def provide(name, opts \\ []) do
    post_query("/routing/provide?arg=#{name}", query: opts)
    |> okify()
  end

  @doc """
  Write a key/value pair to the routing system.

  ## Parameters
    `name` - The name of the key to write.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-routing-put
    verbose - <bool>, # Write extra information.
  """
  @spec put(name, binary, opts) :: {:ok, any} | api_error()
  def put(key, value, opts \\ []) do
    multipart_content(value)
    |> post_multipart("/routing/put?arg=" <> key, query: opts)
    |> okify()
  end
end
