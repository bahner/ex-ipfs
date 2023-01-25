defmodule MyspaceIPFS.ApiTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS, as: Ipfs

  test "get should return a binary when passed a valid key" do
    {:ok, bin} = Ipfs.get("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    assert is_binary(bin)
  end

  test "get should return a :server when passed nothing or invalid key" do
    {:eserver, bin} = Ipfs.get("test_case")
    assert bin["Message"] === "invalid path \"test_case\": illegal base32 data at input byte 3"
    assert bin["Code"] === 0
  end

  doctest MyspaceIPFS.Api
  ## TODO: add Unit testing
end
