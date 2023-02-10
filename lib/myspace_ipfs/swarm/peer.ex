defmodule MyspaceIPFS.SwarmPeer do
  @moduledoc false

  alias MyspaceIPFS.SwarmPeerStream

  defstruct [:addr, :direction, :latency, :muxer, :peer, :streams]

  @spec new(map) :: MyspaceIPFS.Swarm.peer()
  def new(data) when is_map(data) do
    %__MODULE__{
      addr: data["Addr"],
      direction: data["Direction"],
      latency: data["Latency"],
      muxer: data["Muxer"],
      peer: data["Peer"],
      streams: generate_streams(data["Streams"])
    }
  end

  def new(data) when is_list(data) do
    Enum.map(data, &new/1)
  end

  defp generate_peer(data) do
  end

  defp generate_streams(streams) when is_list(streams) do
    Enum.map(streams, &SwarmPeerStream.new/1)
  end

  defp generate_streams(streams) when is_map(streams) do
    Enum.map(streams, &SwarmPeerStream.new/1)
  end

  defp generate_streams(_), do: []
end
