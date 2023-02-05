defmodule MyspaceIPFS.BitswapLedger do
  @moduledoc false
  defstruct [:exchanged, :peer, :recv, :sent, :value]

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.Bitswap.ledger()
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
