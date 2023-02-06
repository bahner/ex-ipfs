defmodule MyspaceIPFS.DhtTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS.Dht

  # defp list_consists_of_dht_query_responses?(list) do
  #   Enum.all?(list, fn x -> %MyspaceIPFS.DhtQueryResponse = dht end)
  # end

  defp list_consists_of_dht_query_responses?(list) do
    Enum.all?(list, fn x -> %MyspaceIPFS.DhtQueryResponse{} = x end)
  end

  test "Should return ok DhtQueryResponse" do
    {:ok, dht} =
      Dht.query("12D3KooWPSp5ZSkLQptkQ7z44xZoYRt3AJMKWe9MmHBECfywVCtD", timeout: 100_000)

    assert is_list(dht)
    assert list_consists_of_dht_query_responses?(dht)
  end
end
