defmodule MyspaceIpfs.DagTest do
  @moduledoc """
  Test the MyspaceIpfs API

  This test suite is designed to test the MyspaceIpfs API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIpfs API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIpfs.Dag, as: Dag

  test "Should return ok RootCID" do
    {:ok, root} = Dag.put("{\"Key\":\"Value\"}")
    assert is_map(root)
    assert %MyspaceIpfs.RootCid{} = root
    assert is_bitstring(root./)
    assert root./ === "bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly"
  end

  test "Should get correct values DAG(from test_json)" do
    {:ok, value} = Dag.get("bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly/Key")
    assert value === "Value"
    {:ok, value} = Dag.get("bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly")
    assert is_list(value)
  end

  test "Should export dag OK" do
    {:ok, value} = Dag.export("bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly")
    assert is_bitstring(value)
  end

  test "Should import dag OK" do
    {:ok, value} = Dag.export("bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly")
    {:ok, import} = Dag.import(value)
    assert is_map(import)
    assert is_map(import.root)
    assert is_map(import.stats)
    assert %MyspaceIpfs.DagImport{} = import
    assert %MyspaceIpfs.DagImportRoot{} = import.root
    assert %MyspaceIpfs.DagImportStats{} = import.stats
    assert import.root.cid./ === "bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly"
    assert import.root.pin_error_msg === ""
    assert is_integer(import.stats.block_bytes_count)
    assert is_integer(import.stats.block_count)
  end

  doctest MyspaceIpfs.Dag
end
