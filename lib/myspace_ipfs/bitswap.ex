defmodule MyspaceIpfs.Bitswap do
  @moduledoc """
  MyspaceIpfs.Bitswap is where the bitswap commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils
  alias MyspaceIpfs.BitswapStat
  alias MyspaceIpfs.BitswapWantList
  alias MyspaceIpfs.BitswapLedger
  require Logger

  @typep okresult :: MySpaceIPFS.okresult()
  @typep peer_id :: MyspaceIpfs.peer_id()
  @type wantlist :: MyspaceIpfs.BitswapWantList.t()
  @type stat :: MyspaceIpfs.BitswapStat.t()
  @type ledger() :: MyspaceIpfs.BitswapLedger.t()
  @typep opts :: MyspaceIpfs.opts()

  @spec reprovide(timeout) :: :okresult
  @doc """
  Reprovide blocks to the network.

  NB! I am unsure what is supposed to happen here. Mostly I get no reply. I haven't been able to find any documentation on this endpoint.
  """
  def reprovide(timeout \\ 5_000) do
    reprovide = Task.async(fn -> post_query("/bitswap/reprovide") end)

    case Task.yield(reprovide, timeout) || Task.shutdown(reprovide) do
      {:ok, result} ->
        result

      nil ->
        Logger.warn("Bitswap.reprovide timed out after #{timeout}ms. That is probably OK.")
        :ok
    end
  end

  @doc """
  Get the current bitswap wantlist.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-wantlist

  `peer` - The peer ID to get the wantlist for. Optional.
  """
  @spec wantlist() :: okresult()
  def wantlist() do
    post_query("/bitswap/wantlist")
    |> snake_atomize()
    |> BitswapWantList.new()
    |> okify()
  end

  @spec wantlist(peer_id) :: {:ok, wantlist} | {:error, String.t()}
  def wantlist(peer) do
    post_query("/bitswap/wantlist?peer=" <> peer)
    |> snake_atomize()
    |> BitswapWantList.new()
    |> okify()
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
  @spec stat(opts) :: {:ok, [stat]} | {:error, any()}
  def stat(opts \\ []) do
    post_query("/bitswap/stat", query: opts)
    |> snake_atomize()
    |> BitswapStat.new()
  end

  @doc """
  Get the current bitswap ledger for a given peer.

  ## Parameters
  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-ledger

  `peer` - The peer ID to get the ledger for.
  """
  @spec ledger(peer_id) :: {:ok, [ledger]} | {:error, any()}
  def ledger(peer) do
    post_query("/bitswap/ledger?arg=" <> peer)
    |> snake_atomize()
    |> BitswapLedger.new()
  end
end
