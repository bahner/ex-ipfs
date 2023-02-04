defmodule MyspaceIPFS.Stats do
  @moduledoc """
  MyspaceIPFS.Stats is where the stats commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep api_error :: MyspaceIPFS.ApiError.t()
  @typep opts :: MyspaceIPFS.opts()
  @typep name :: MyspaceIPFS.name()

  @doc """
  Show some diagnostic information on the bitswap agent.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-stats-bitswap
    human - <bool>, # Output human-readable numbers.
    verbose - <bool>, # Print extra information.
  """
  @spec bitswap(opts) :: {:ok, any} | api_error()
  def bitswap(opts \\ []) do
    post_query("/stats/bitswap", query: opts)
  end

  @doc """
  Print ipfs bandwidth information.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-stats-bw
    peer - <string>, # Specify a peer to print bandwidth for.
    proto - <string>, # Specify a protocol to print bandwidth for.
    poll - <bool>, # Poll for stats.
    interval - <string>, # Time interval to poll. Default: 1s.
  """
  @spec bw(opts) :: {:ok, any} | api_error()
  def bw(opts \\ []) do
    post_query("/stats/bw", query: opts)
  end

  @doc """
  Return the statistics about the nodes DHT(s).

  ## Parameters
    dht - <string>, # The name of the DHT to query.
                    # "wanserver", "lanserver", "lan" or "wan".
  """
  @spec dht(name) :: {:ok, any} | api_error
  def dht(name) do
    post_query("/stats/dht?arg=#{name}")
    |> okify()
  end

  @doc """
  Returns statistics about the node's (re)provider system.
  """
  @spec provide() :: {:ok, any} | api_error()
  def provide do
    post_query("/stats/provide")
    |> okify()
  end

  @doc """
  Get stats for the currently running repo.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-stats-repo
    human - <bool>, # Output human-readable numbers.
    size-only - <bool>, # Only report the RepoSize.
  """
  @spec repo(opts) :: {:ok, any} | api_error()
  def repo(opts \\ []) do
    post_query("/stats/repo", query: opts)
    |> okify()
  end
end
