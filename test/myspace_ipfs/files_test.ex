defmodule MyspaceIPFS.FilesTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS.Files
  require Logger

  test "Cleanup up silently" do
    assert :ok = Files.rm("/test", recursive: true, force: true)
    Logger.info("Sleeping for 5 seconds to allow the files to be removed.")
    :timer.sleep(5_000)
  end

  test "Make sure test folder is gone" do
    {:error, api_error} = Files.ls("/test")
    assert api_error.message == "file does not exist"
  end

  test "Fail to create an unparented folder" do
    {:error, api_error} = Files.mkdir("/test/illegal")
    assert api_error.message == "file does not exist"
  end

  test "Create a parented folder" do
    assert :ok = Files.mkdir("/test/illegal", parents: true)
  end

  test "ls root" do
    {:ok, %MyspaceIPFS.FilesEntries{entries: files}} = Files.ls("/")
    assert is_list(files)
    assert Enum.member?(files, "test")
  end
end
