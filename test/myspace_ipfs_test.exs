defmodule MyspaceIPFSTest do
  @moduledoc """
  Test the MyspaceIPFS module

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true

  test "id should return a list of ID maps" do
    {:ok, response} = MyspaceIPFS.id()

    # FIXME
    # Response looks like this. All values seems to be charlists (not bitstrings),
    # which is probably not what we want. Data returned from API endpoinst should be
    # converted to regular strings (which are waay easier to work with).
    # [
    #   %{
    #     'Addresses' => [
    #       '/ip4/127.0.0.1/tcp/4001/p2p/12D3KooWJYAA2L8XZZwUnCDfM6km4h7WkGdXYzszJwL9iQW3Lggo',
    #       '/ip4/127.0.0.1/udp/4001/quic/p2p/12D3KooWJYAA2L8XZZwUnCDfM6km4h7WkGdXYzszJwL9iQW3Lggo',
    #       '/ip4/172.22.0.2/tcp/4001/p2p/12D3KooWJYAA2L8XZZwUnCDfM6km4h7WkGdXYzszJwL9iQW3Lggo',
    #       '/ip4/172.22.0.2/udp/4001/quic/p2p/12D3KooWJYAA2L8XZZwUnCDfM6km4h7WkGdXYzszJwL9iQW3Lggo'
    #     ],
    #     'AgentVersion' => 'kubo/0.17.0/4485d6b/docker',
    #     'ID' => '12D3KooWJYAA2L8XZZwUnCDfM6km4h7WkGdXYzszJwL9iQW3Lggo',
    #     'ProtocolVersion' => 'ipfs/0.1.0',
    #     'Protocols' => [
    #       '/ipfs/bitswap',
    #       '/ipfs/bitswap/1.0.0',
    #       '/ipfs/bitswap/1.1.0',
    #       '/ipfs/bitswap/1.2.0',
    #       '/ipfs/id/1.0.0',
    #       '/ipfs/id/push/1.0.0',
    #       '/ipfs/lan/kad/1.0.0',
    #       '/ipfs/ping/1.0.0',
    #       '/libp2p/autonat/1.0.0',
    #       '/libp2p/circuit/relay/0.1.0',
    #       '/libp2p/circuit/relay/0.2.0/stop',
    #       '/p2p/id/delta/1.0.0',
    #       '/x/'
    #     ],
    #     'PublicKey' => 'CAESIIGSTpDo8ps4K+2f2gIsX4EGCfSBP3OlJemdihtLnav4'
    #   }
    # ]

    Enum.each(response, fn id ->
      assert is_map(id)
      assert is_list(Map.fetch!(id, 'ID'))
      assert is_list(Map.fetch!(id, 'PublicKey'))
      assert is_list(Map.fetch!(id, 'Addresses'))
      assert is_list(Map.fetch!(id, 'AgentVersion'))
      assert is_list(Map.fetch!(id, 'ProtocolVersion'))
      assert is_list(Map.fetch!(id, 'Protocols'))
    end)
  end
end
