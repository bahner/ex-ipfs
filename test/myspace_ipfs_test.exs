defmodule MyspaceIpfsTest do
  @moduledoc """
  Test the MyspaceIpfs module

  This test suite is designed to test the MyspaceIpfs API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIpfs API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node.
  """
  use ExUnit.Case, async: true

  test "id should return an ID map og specific structure" do
    {:ok, response} = MyspaceIpfs.id()

    assert is_map(response)
    assert is_binary(Map.fetch!(response, "AgentVersion"))
    assert is_binary(Map.fetch!(response, "ID"))
    assert is_binary(Map.fetch!(response, "ProtocolVersion"))
    assert is_binary(Map.fetch!(response, "PublicKey"))
    assert is_list(Map.fetch!(response, "Addresses"))
    assert is_list(Map.fetch!(response, "Protocols"))
  end
end
