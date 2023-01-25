defmodule MyspaceIpfs.BitswapStat do
  @moduledoc """
  A struct that represents the bitswap network statistics.
  """

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
end
