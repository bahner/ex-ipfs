defmodule MyspaceIPFSApiTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true

  alias MyspaceIPFS.Api, as: Api

  test "id should return a complete map" do
    {:ok, response} = Api.id()
    assert is_map(response)
    assert is_bitstring(Map.fetch!(response, "ID"))
    assert is_bitstring(Map.fetch!(response, "PublicKey"))
    assert is_list(Map.fetch!(response, "Addresses"))
    assert is_bitstring(Map.fetch!(response, "AgentVersion"))
    assert is_bitstring(Map.fetch!(response, "ProtocolVersion"))
    assert is_list(Map.fetch!(response, "Protocols"))
  end

  test "get should return a binary when passed a valid key" do
    {:ok, bin} = Api.get("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    assert is_binary(bin)
  end

  test "get should return a servererror when passed nothing or invalid key" do
    {:server_error, bin} = Api.get("test_case")
    assert is_map(bin)
    assert bin["Message"] === "invalid path \"test_case\": illegal base32 data at input byte 3"
    assert bin["Code"] === 0
  end

  ## TODO: add Unit testing
end
