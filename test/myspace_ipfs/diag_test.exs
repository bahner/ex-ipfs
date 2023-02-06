defmodule MyspaceIPFS.DiagTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS.Diag

  # defp list_consists_of_dht_query_responses?(list) do
  #   Enum.all?(list, fn x -> %MyspaceIPFS.DhtQueryResponse = dht end)
  # end

  defp list_consists_of_diag_cmds?(list) do
    Enum.all?(list, fn x -> %MyspaceIPFS.DiagCmd{} = x end)
  end

  test "Should return ok DiagCmds" do
    {:ok, diag} = Diag.cmds()

    assert is_list(diag)
    assert list_consists_of_diag_cmds?(diag)
  end

  test "Should return ok DiagClear" do
    {:ok, diag} = Diag.clear()

    assert diag == ""
  end

  test "Should return ok DiagSetTime" do
    {:ok, diag} = Diag.set_time("1h")

    assert diag == ""
  end

  test "Should return ok DiagSys" do
    {:ok, diag} = Diag.sys()

    assert is_map(diag)
    assert Map.has_key?(diag, "memory")
    assert Map.has_key?(diag, "diskinfo")
    assert Map.has_key?(diag, "net")
    assert Map.has_key?(diag, "runtime")
    assert Map.has_key?(diag, "environment")
    assert Map.has_key?(diag, "ipfs_commit")
    assert Map.has_key?(diag, "ipfs_version")
  end

  # NB! This test doesnæt actually write data to the profile.
  # It just checks that the profile is created.
  # And the process is alive and doing something.
  test "Should save profile to file" do
    {:ok, pid} = Diag.profile(output: "/tmp/test.prof", timeout: "1s")

    assert is_pid(pid)
    :timer.sleep(2_000)
    assert Process.alive?(pid)
    assert File.exists?("/tmp/test.prof")
  end
end
