defmodule MyspaceIPFS.SwarmPeerStreamTest do
  @moduledoc false
  use ExUnit.Case

  alias MyspaceIPFS.SwarmPeerStream

  test "new/1 returns a SwarmPeerStream struct" do
    data = %{"Protocol" => "test"}
    assert %SwarmPeerStream{protocol: "test"} = SwarmPeerStream.new(data)
  end
end
