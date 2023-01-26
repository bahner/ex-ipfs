defmodule MyspaceIpfs.BitswapLedger do
  @moduledoc """
  A struct that represents the ledger for a peer in the bitswap network.
  """
  defstruct [:exchanged, :peer, :recv, :sent, :value]

  @typep peer_id :: MyspaceIpfs.PeerID.t()
  @type t :: %__MODULE__{
          exchanged: pos_integer(),
          peer: peer_id,
          recv: pos_integer(),
          sent: pos_integer(),
          value: float()
        }
end
