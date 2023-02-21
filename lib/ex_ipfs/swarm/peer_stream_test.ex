defmodule ExIPFS.SwarmPeerStream do
  @moduledoc false

  defstruct [:protocol]

  @spec new(map) :: ExIPFS.Swarm.peer_stream()
  def new(data) do
    %__MODULE__{
      protocol: data["Protocol"]
    }
  end
end
