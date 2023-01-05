defmodule MyspaceIPFSTest do
  @moduledoc """
  Test the MyspaceIPFS module

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node.
  """
  use ExUnit.Case, async: true

  test "id should return an ID map og specific structure" do
    {:ok, response} = MyspaceIPFS.id()

    assert is_map(response)
    assert is_binary(Map.fetch!(response, "AgentVersion"))
    assert is_binary(Map.fetch!(response, "ID"))
    assert is_binary(Map.fetch!(response, "ProtocolVersion"))
    assert is_binary(Map.fetch!(response, "PublicKey"))
    assert is_list(Map.fetch!(response, "Addresses"))
    assert is_list(Map.fetch!(response, "Protocols"))
  end
end
