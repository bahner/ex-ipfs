defmodule MyspaceIpfs.BitswapLedger do
  @moduledoc """
  A struct that represents the ledger for a peer in the bitswap network.
  """
  import MyspaceIpfs.Utils

  defstruct [:exchanged, :peer, :recv, :sent, :value]

  @typep peer_id :: MyspaceIpfs.PeerID.t()
  @type t :: %__MODULE__{
          exchanged: pos_integer(),
          peer: peer_id,
          recv: pos_integer(),
          sent: pos_integer(),
          value: float()
        }

  @doc """
  Generate a new BitswapLedger struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIpfs.BitswapLedger.t()
  def new(opts) do
    opts = snake_atomize(opts)

    %__MODULE__{
      exchanged: opts.exchanged,
      peer: opts.peer,
      recv: opts.recv,
      sent: opts.sent,
      value: opts.value
    }
  end
end
