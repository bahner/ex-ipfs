defmodule MyspaceIPFS.SwarmPeerStream do
  @moduledoc false

  defstruct [:protocol]

  @spec new(map) :: MyspaceIPFS.Swarm.peer_stream()
  def new(data) do
    %__MODULE__{
      protocol: data["Protocol"]
    }
  end
end
