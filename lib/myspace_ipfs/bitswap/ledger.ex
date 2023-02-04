defmodule MyspaceIPFS.BitswapLedger do
  @moduledoc """
  A struct that represents the ledger for a peer in the bitswap network.
  """
  import MyspaceIPFS.Utils

  defstruct [:exchanged, :peer, :recv, :sent, :value]

  @typep peer_id :: MyspaceIPFS.peer_id()
  @type t :: %__MODULE__{
          exchanged: pos_integer(),
          peer: peer_id,
          recv: pos_integer(),
          sent: pos_integer(),
          value: float()
        }

  @doc false
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.BitswapLedger.t()
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
