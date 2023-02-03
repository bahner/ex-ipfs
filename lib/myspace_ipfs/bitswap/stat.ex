defmodule MyspaceIpfs.BitswapStat do
  @moduledoc """
  A struct that represents the bitswap network statistics.
  """

  import MyspaceIpfs.Utils

  defstruct blocks_received: nil,
            blocks_sent: nil,
            data_received: nil,
            data_sent: nil,
            dup_blks_received: nil,
            dup_data_received: nil,
            messages_received: nil,
            peers: [],
            provide_buf_len: nil,
            wantlist: []

  @typep rootcid :: MyspaceIpfs.RootCid.t()
  @typep peer_id :: MyspaceIpfs.peer_id()

  @type t :: %__MODULE__{
          blocks_received: non_neg_integer,
          blocks_sent: non_neg_integer,
          data_received: non_neg_integer,
          data_sent: non_neg_integer,
          dup_blks_received: non_neg_integer,
          dup_data_received: non_neg_integer,
          messages_received: list,
          peers: list(peer_id),
          provide_buf_len: integer,
          wantlist: list(rootcid)
        }

  @doc """
  Generate a new BitswapStat struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIpfs.BitswapStat.t()
  def new(opts) do
    opts = snake_atomize(opts)

    %__MODULE__{
      blocks_received: opts.blocks_received,
      blocks_sent: opts.blocks_sent,
      data_received: opts.data_received,
      data_sent: opts.data_sent,
      dup_blks_received: opts.dup_blks_received,
      dup_data_received: opts.dup_data_received,
      messages_received: opts.messages_received,
      peers: opts.peers,
      provide_buf_len: opts.provide_buf_len,
      wantlist: opts.wantlist
    }
  end
end
