defmodule MyspaceIPFS.SwarmPeerTest do
  @moduledoc false
  use ExUnit.Case

  alias MyspaceIPFS.SwarmPeer

  @data %{
    "Addr" => "/ip4/foo/bar",
    "Direction" => "test",
    "Latency" => "test",
    "Muxer" => "test",
    "Peer" => "test",
    "Streams" => [%{"Protocol" => "test"}]
  }

  test "new/1 returns a SwarmPeer struct" do
    assert %SwarmPeer{
             addr: "/ip4/foo/bar",
             direction: "test",
             latency: "test",
             muxer: "test",
             peer: "test",
             streams: [%MyspaceIPFS.SwarmPeerStream{protocol: "test"}]
           } = SwarmPeer.new(@data)
  end
end
