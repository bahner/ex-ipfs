defmodule MExIPFS.SwarmPeersTest do
  @moduledoc false
  use ExUnit.Case

  alias ExIPFS.SwarmPeers

  @peers %{
    "Peers" => [
      %{
        "Addr" => "/ip4/foo/bar",
        "Direction" => "test",
        "Latency" => "test",
        "Muxer" => "test",
        "Peer" => "test",
        "Streams" => [%{"Protocol" => "test"}]
      },
      %{
        "Addr" => "/ip4/foo/bar",
        "Direction" => "test",
        "Latency" => "test",
        "Muxer" => "test",
        "Peer" => "test",
        "Streams" => [%{"Protocol" => "test"}]
      }
    ]
  }

  test "create swarm peers" do
    assert %SwarmPeers{} = SwarmPeers.new(@peers)
  end
end
