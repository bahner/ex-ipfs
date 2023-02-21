defmodule ExIPFS.SwarmPeers do
  @moduledoc false

  alias ExIPFS.SwarmPeer

  defstruct [:peers]

  @spec new(map) :: ExIPFS.Swarm.peers()
  def new(data) when is_map(data) do
    %__MODULE__{
      peers: gen_peerlist(data["Peers"])
    }
  end

  def new(nil), do: %__MODULE__{peers: []}

  @spec new({:error, any}) :: {:error, any}
  def new({:error, error}), do: {:error, error}

  defp gen_peerlist(peers) when is_list(peers) do
    Enum.map(peers, &SwarmPeer.new/1)
  end
end
