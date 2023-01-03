defmodule MyspaceIPFS.Bitswap do
  @moduledoc """
  MyspaceIPFS.Bitswap is where the bitswap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils

  @typep okmapped :: MySpaceIPFS.okmapped()
  @typep opts :: MySpaceIPFS.opts()
  @typep peer_id :: MySpaceIPFS.peer_id()

  @doc """
  Get the current bitswap ledger for a given peer.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-ledger

  `peer` - The peer ID to get the ledger for.
  """
  @spec ledger(peer_id) :: okmapped()
  def ledger(peer) do
    post_query("/bitswap/ledger?arg=" <> peer)
    |> handle_plain_response()
  end

  @doc """
  Show some diagnostic information on the bitswap agent.

  ## Options
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-stat
  ```
  [
    `verbose`: <bool>, # Print extra information.
    `human`: <bool>, # Print sizes in human readable format (e.g., 1.2K 234M 2G).
  ]
  ```
  """
  @spec stat(opts) :: okmapped()
  def stat(opts \\ []) do
    post_query("/bitswap/stat", query: opts)
    |> handle_plain_response()
  end

  @doc """
  Reprovide blocks to the network.
  """
  @spec reprovide() :: okmapped()
  def reprovide do
    post_query("/bitswap/reprovide")
    |> handle_plain_response()
  end

  @doc """
  Get the current bitswap wantlist.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-wantlist

  `peer` - The peer ID to get the wantlist for. Optional.
  """
  @spec wantlist() :: okmapped()
  def wantlist() do
    post_query("/bitswap/wantlist")
    |> handle_plain_response()
  end

  @spec wantlist(peer_id) :: okmapped()
  def wantlist(peer) do
    post_query("/bitswap/wantlist?peer=" <> peer)
    |> handle_plain_response()
  end
end
