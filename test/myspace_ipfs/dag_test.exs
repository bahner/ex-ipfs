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
    assert root./ === "bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly"
    assert %MyspaceIpfs.RootCid{} = root
  end

  test "Should get correct value from test_json" do
    {:ok, value} = Dag.get("bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly/Key")
    assert value === "Value"
  end

  test "Should export dag OK" do
    {:ok, value} = Dag.export("bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly")
    assert is_bitstring(value)
  end

  test "Should import dag OK" do
    {:ok, value} = Dag.export("bafyreia353cr2t26iiuw5g2triyfelqehsu5peq4pn2u6t6q6oktrplzly")
    {:ok, root} = Dag.import(value)
    # assert is_bitstring(value)
    # assert is_binary(root)
    # assert is_map(import_value)
    # assert import.root=== root./
  end

  doctest MyspaceIpfs.Dag
end
