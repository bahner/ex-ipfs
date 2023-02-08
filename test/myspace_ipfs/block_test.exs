defmodule MyspaceIPFS.BlockTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  @timeout 180_000
  use ExUnit.Case, async: true
  @moduletag timeout: @timeout
  ExUnit.configure(seed: 0, timeout: @timeout)

  alias MyspaceIPFS.Block

  ExUnit.configure(timeout: 600_000)

  test "put 'heisan' returns proper keysize" do
    {:ok, keysize} = Block.put("heisan")
    assert is_map(keysize)
    assert %MyspaceIPFS.BlockKeySize{} = keysize
    assert keysize.key === "bafkreidqdr4pgdzfhf5zrwbqhiyqdapniknge6eux74ixk77s2hintta24"
    assert keysize.size === 6
  end

  test "stat 'heisan' returns proper keysize" do
    {:ok, keysize} = Block.stat("bafkreidqdr4pgdzfhf5zrwbqhiyqdapniknge6eux74ixk77s2hintta24")

    assert is_map(keysize)
    assert %MyspaceIPFS.BlockKeySize{} = keysize
    assert keysize.key === "bafkreidqdr4pgdzfhf5zrwbqhiyqdapniknge6eux74ixk77s2hintta24"
    assert keysize.size === 6
  end

  test "Put file larger than 1Mb returns error" do
    {:error, api_error} = Block.put_file("/bin/bash")
    assert is_map(api_error)
    assert %MyspaceIPFS.ApiError{} = api_error
    assert api_error.code === 0

    assert api_error.message ===
             "produced block is over 1MiB: big blocks can't be exchanged with other peers. consider using UnixFS for automatic chunking of bigger files, or pass --allow-big-block to override"

    assert api_error.type === "error"
  end

  test "put large file with allow-big-block returns proper keysize" do
    {:ok, keysize} = Block.put_file("/bin/bash", "allow-big-block": true)
    assert is_map(keysize)
    assert %MyspaceIPFS.BlockKeySize{} = keysize
    assert String.starts_with?(keysize.key, "baf")
    assert is_integer(keysize.size)
  end

  test "get QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx returns correct block value" do
    {:ok, block} = Block.get("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    assert is_binary(block)

    assert block ===
             <<10, 19, 8, 2, 18, 13, 104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 115,
               10, 24, 13>>
  end

  test "get and rm QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx" do
    {:ok, _} = Block.get("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    {:ok, hash} = Block.rm("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    assert is_map(hash)
    assert %MyspaceIPFS.BlockErrorHash{} = hash
    assert hash.hash === "QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx"
  end

  test "repeated rm QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx give error" do
    {:ok, _} = Block.get("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    # It takes some time for the blocvk to be removed
    {:ok, _} = Block.rm("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    {:ok, _} = Block.rm("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    {:ok, hash} = Block.rm("QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx")
    assert is_map(hash)
    assert %MyspaceIPFS.BlockErrorHash{} = hash
    assert hash.hash === "QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx"
    assert hash.error === "ipld: could not find QmZ4tDuvesekSs4qM5ZBKpXiZGun7S2CYtEZRB3DYXkjGx"
  end
end
