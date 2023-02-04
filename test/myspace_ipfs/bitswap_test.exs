defmodule MyspaceIPFS.BitswapTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS.Bitswap

  test "Should return error on 2nd call" do
    Bitswap.reprovide()
    {:error, api_error} = Bitswap.reprovide()
    assert is_map(api_error)
    assert %MyspaceIPFS.ApiError{} = api_error
    assert api_error.code === 0
    assert api_error.message === "reprovider is already running"
    assert api_error.type === "error"
  end

  test "wantlist should return wantlist" do
    {:ok, wantlist} = Bitswap.wantlist()
    assert is_map(wantlist)
    assert %MyspaceIPFS.BitswapWantList{} = wantlist
    assert is_list(wantlist.keys)
  end

  test "ledger should return ledger" do
    # This might very well fail. I on't know how to get a peer ID to test this with.
    # Hopefully it will work on the CI server.
    peer_id = "QmXwE6L49d826uNWT9E2Dma3sUetaKTQNnXAJ2QAm9dCgz"
    {:ok, ledger} = Bitswap.ledger(peer_id)
    assert is_map(ledger)
    assert %MyspaceIPFS.BitswapLedger{} = ledger
    assert ledger.peer === peer_id
  end

  test "stat should return stat" do
    {:ok, stat} = Bitswap.stat()
    assert is_map(stat)
    assert %MyspaceIPFS.BitswapStat{} = stat
    assert stat.provide_buf_len === 0
    assert is_list(stat.wantlist)
    assert is_integer(stat.blocks_received)
    assert stat.blocks_received >= 0
    assert is_integer(stat.dup_blks_received)
    assert stat.dup_blks_received >= 0
    assert is_integer(stat.dup_data_received)
    assert stat.dup_data_received >= 0
    assert is_integer(stat.data_received)
    assert stat.data_received >= 0
    assert is_integer(stat.blocks_sent)
    assert stat.blocks_sent >= 0
    assert is_integer(stat.data_sent)
    assert is_list(stat.peers)
    assert is_integer(stat.provide_buf_len)
    assert stat.provide_buf_len >= 0
  end
end
