defmodule MyspaceIPFS.BitswapLedger do
  @moduledoc """
  MyspaceIPFS.BitswapLedger is a struct returned from the IPFS Bitswap API.
  """

  defstruct [:exchanged, :peer, :recv, :sent, :value]

  @type t :: %__MODULE__{
          exchanged: pos_integer(),
          peer: MyspaceIPFS.peer_id(),
          recv: pos_integer(),
          sent: pos_integer(),
          value: float()
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(opts) do

    %__MODULE__{
      exchanged: opts["Exchanged"],
      peer: opts["Peer"],
      recv: opts["Recv"],
      sent: opts["Sent"],
      value: opts["Value"]
    }
  end
end
