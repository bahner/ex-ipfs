defmodule MyspaceIPFS.BitswapStat do
  @moduledoc """
  MyspaceIPFS.BitswapStat is a struct returned from the IPFS Bitswap API.
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

  @type t :: %__MODULE__{
          blocks_received: non_neg_integer,
          blocks_sent: non_neg_integer,
          data_received: non_neg_integer,
          data_sent: non_neg_integer,
          dup_blks_received: non_neg_integer,
          dup_data_received: non_neg_integer,
          messages_received: list,
          peers: list(MyspaceIPFS.peer_id()),
          provide_buf_len: integer,
          wantlist: list(MyspaceIPFS.SlashCID.t())
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(opts) do
    %__MODULE__{
      blocks_received: opts["BlocksReceived"],
      blocks_sent: opts["BlocksSent"],
      data_received: opts["DataReceived"],
      data_sent: opts["DataSent"],
      dup_blks_received: opts["DupBlksReceived"],
      dup_data_received: opts["DupDataReceived"],
      messages_received: opts["MessagesReceived"],
      peers: opts["Peers"],
      provide_buf_len: opts["ProvideBufLen"],
      wantlist: opts["Wantlist"]
    }
  end
end
