defmodule MyspaceIpfs.ApiTest do
  @moduledoc """
  Test the MyspaceIpfs API

  This test suite is designed to test the MyspaceIpfs API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIpfs API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIpfs, as: Ipfs

  test "get should return a binary when passed a valid key" do
    {:ok, bin} = Ipfs.get("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    assert is_binary(bin)
  end

  test "get should return a :server when passed nothing or invalid key" do
    {:error, bin} = Ipfs.get("test_case")
    assert bin.message === "invalid path \"test_case\": illegal base32 data at input byte 3"
    assert bin.code === 0
  end

  doctest MyspaceIpfs.Api
  ## TODO: add Unit testing
end
