defmodule MyspaceIPFS.Routing do
  @moduledoc """
  MyspaceIPFS.Routing is where the routing commands of the IPFS API reside.
  """

  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep peer_id :: MyspaceIPFS.peer_id()
  @typep opts :: MyspaceIPFS.opts()
  @typep name :: MyspaceIPFS.name()

  @doc """
  Find the multiaddresses associated with a peer ID.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-routing-findpeer
    verbose - <bool>, # Write extra information.
  """
  @spec findpeer(peer_id, opts) :: okresult
  def findpeer(peer_id, opts \\ []) do
    post_query("/routing/findpeer?arg=#{peer_id}", query: opts)
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Find peers that can provide a specific value, given a key.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-routing-findprovs
    verbose - <bool>, # Write extra information.
    num-providers - <int>, # The number of providers to find.
  """
  @spec findprovs(peer_id, opts) :: okresult
  def findprovs(cid, opts \\ []) do
    post_query("/routing/findprovs?arg=#{cid}", query: opts)
    |> handle_api_response()
    |> okify()
  end

  @doc """
  Announce to the network that you are providing given values.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-routing-provide
    recursive - <bool>, # Recursively provide entire graph.
    verbose - <bool>, # Write extra information.
  """
  @spec provide(name, opts) :: okresult
  def provide(name, opts \\ []) do
    post_query("/routing/provide?arg=#{name}", query: opts)
    |> handle_api_response()
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
  @spec put(name, binary, opts) :: okresult
  def put(key, value, opts \\ []) do
    multipart_content(value)
    |> post_multipart("/routing/put?arg=" <> key, query: opts)
    |> handle_api_response()
    |> okify()
  end
end
