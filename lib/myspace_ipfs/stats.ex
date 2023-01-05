defmodule MyspaceIPFS.Stats do
  @moduledoc """
  MyspaceIPFS.Stats is where the stats commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okresult :: MyspaceIPFS.okresult()
  @typep opts :: MyspaceIPFS.opts()
  @typep name :: MyspaceIPFS.name()

  @doc """
  Show some diagnostic information on the bitswap agent.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-stats-bitswap
    human - <bool>, # Output human-readable numbers.
    verbose - <bool>, # Print extra information.
  """
  @spec bitswap(opts) :: okresult
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
  @spec bw(opts) :: okresult
  def bw(opts \\ []) do
    post_query("/stats/bw", query: opts)
  end

  @doc """
  Return the statistics about the nodes DHT(s).

  ## Parameters
    dht - <string>, # The name of the DHT to query.
                    # "wanserver", "lanserver", "lan" or "wan".
  """
  @spec dht(name) :: MyspaceIPFS.okmapped()
  def dht(name) do
    post_query("/stats/dht?arg=#{name}")
    |> handle_plain_response()
  end

  @doc """
  Returns statistics about the node's (re)provider system.
  """
  @spec provide() :: okresult
  def provide do
    post_query("/stats/provide")
    |> handle_json_response()
  end

  @doc """
  Get stats for the currently running repo.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-stats-repo
    human - <bool>, # Output human-readable numbers.
    size-only - <bool>, # Only report the RepoSize.
  """
  @spec repo(opts) :: okresult
  def repo(opts \\ []) do
    post_query("/stats/repo", query: opts)
    |> handle_json_response()
  end
end
