defmodule ExIpfs.ApiTest do
  @moduledoc """
  Test the ExIpfs API

  This test suite is designed to test the ExIpfs API. It is not designed to test the IPFS API
  itself. It is designed to test the ExIpfs API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias ExIpfs, as: Ipfs

  test "get should return a binary when passed a valid key" do
    {:ok, bin} = Ipfs.get("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    assert is_binary(bin)
    # Clean up
    File.rm!("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
  end

  test "get should return a :server when passed nothing or invalid key" do
    {:error, bin} = Ipfs.get("test_case")

    assert bin.message ===
             "invalid path \"test_case\": path does not have enough components"

    assert bin.code === 0
  end

  doctest ExIpfs.Api

  test "post_query returns 404" do
    {:error, response} = Ipfs.Api.post_query("test")
    assert %Tesla.Env{} = response
    assert response.status == 404
  end

  test "post_query returns 400" do
    {:error, response} = Ipfs.Api.post_query("/id?arg=foo")
    assert %ExIpfs.ApiError{} = response
  end
end
