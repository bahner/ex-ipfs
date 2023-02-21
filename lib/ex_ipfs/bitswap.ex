defmodule ExIPFS.Bitswap do
  @moduledoc """
  ExIPFS.Bitswap is where the bitswap commands of the IPFS API reside.
  """
  import ExIPFS.Api
  import ExIPFS.Utils
  alias ExIPFS.BitswapStat
  alias ExIPFS.BitswapWantList
  alias ExIPFS.BitswapLedger
  require Logger

  @spec reprovide(timeout) :: :ok

  @typedoc """
  A struct that represents the stats for the bitswap network.
  """
  @type stat :: %ExIPFS.BitswapStat{
          blocks_received: non_neg_integer,
          blocks_sent: non_neg_integer,
          data_received: non_neg_integer,
          data_sent: non_neg_integer,
          dup_blks_received: non_neg_integer,
          dup_data_received: non_neg_integer,
          messages_received: list,
          peers: list(ExIPFS.peer_id()),
          provide_buf_len: integer,
          wantlist: list(ExIPFS.link())
        }

  @typedoc """
  A struct that represents the wantlist for a peer in the bitswap network.

  """
  @type wantlist :: %ExIPFS.BitswapWantList{
          keys: list | nil
        }

  @typedoc """
  A struct that represents the ledger for a peer in the bitswap network.
  """
  @type ledger :: %ExIPFS.BitswapLedger{
          exchanged: pos_integer(),
          peer: ExIPFS.peer_id(),
          recv: pos_integer(),
          sent: pos_integer(),
          value: float()
        }

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
  @spec wantlist() :: {:ok, wantlist()} | ExIPFS.Api.error_response()
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
  @spec wantlist(ExIPFS.peer_id()) :: {:ok, wantlist()} | ExIPFS.Api.error_response()
  def wantlist(peer) when is_binary(peer) do
    post_query("/bitswap/wantlist?peer=" <> peer)
    |> BitswapWantList.new()
    |> okify()
  end

  @doc """
  Show some diagnostic information on the bitswap agent.

  https://docs.ipfs.tech/reference/kubo/rpc/#api-v0-bitswap-stat
  """
  # @spec stat(list()) ::
  #         {:ok, [ExIPFS.BitswapStat.t()]}
  #         | ExIPFS.Api.error_response()
  @spec stat(list()) :: {:ok, [stat()]} | ExIPFS.Api.error_response()

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
  @spec ledger(ExIPFS.peer_id()) :: {:ok, [ledger()]} | ExIPFS.Api.error_response()
  def ledger(peer) do
    post_query("/bitswap/ledger?arg=" <> peer)
    |> BitswapLedger.new()
    |> okify()
  end
end
