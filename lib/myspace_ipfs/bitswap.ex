defmodule MyspaceIPFS.Bitswap do
  @moduledoc """
  MyspaceIPFS.Bitswap is where the bitswap commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.BitswapStat
  alias MyspaceIPFS.BitswapWantList
  alias MyspaceIPFS.BitswapLedger
  require Logger

  @typep api_error :: MyspaceIPFS.Api.api_error()
  @typep api_response :: MyspaceIPFS.Api.api_response()
  @typep peer_id :: MyspaceIPFS.peer_id()
  @typep opts :: MyspaceIPFS.opts()

  @spec reprovide(timeout) :: :ok
  @doc """
  Reprovide blocks to the network.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-reprovide

  NB! I am unsure what is supposed to happen here. Mostly I get no reply. I haven't been able to find any documentation on this endpoint.
  """
  def reprovide(timeout \\ 5_000) do
    reprovide = Task.async(fn -> post_query("/bitswap/reprovide") end)

    case Task.yield(reprovide, timeout) || Task.shutdown(reprovide) do
      # A bit strange, but the error is returned in an {:ok, error} tuple.
      {:ok, {:error, result}} ->
        {:error, result}

      _ ->
        Logger.warn("Bitswap.reprovide timed out after #{timeout}ms. That is probably OK.")
        :ok
    end
  end

  @doc """
  Get the current bitswap wantlist.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-wantlist
  """
  @spec wantlist() :: {:ok, MyspaceIPFS.BitswapWantList.t()} | api_error()
  def wantlist() do
    post_query("/bitswap/wantlist")
    |> BitswapWantList.new()
    |> okify()
  end

  @doc """
  Get the current bitswap wantlist for a peer.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-wantlist

  ## Parameters
  `peer` - The peer ID to get the wantlist for. Optional.
  """
  @spec wantlist(peer_id) :: {:ok, MyspaceIPFS.BitswapWantList.t()} | api_error()
  def wantlist(peer) when is_binary(peer) do
    post_query("/bitswap/wantlist?peer=" <> peer)
    |> BitswapWantList.new()
    |> okify()
  end

  @doc """
  Show some diagnostic information on the bitswap agent.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-stat
  """
  @spec stat(opts) :: {:ok, [MyspaceIPFS.BitswapWantStat.t()]} | api_response
  def stat(opts \\ []) do
    post_query("/bitswap/stat", query: opts)
    |> BitswapStat.new()
    |> okify()
  end

  @doc """
  Get the current bitswap ledger for a given peer.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-ledger

  ## Parameters
  `peer` - The peer ID to get the ledger for.
  """
  @spec ledger(peer_id) :: {:ok, [MyspaceIPFS.BitswapLedger.t()]} | api_error
  def ledger(peer) do
    post_query("/bitswap/ledger?arg=" <> peer)
    |> BitswapLedger.new()
    |> okify()
  end
end
