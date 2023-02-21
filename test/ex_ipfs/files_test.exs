defmodule ExIPFS.FilesTest do
  @moduledoc """
  Test the ExIPFS API

  This test suite is designed to test the ExIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the ExIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias ExIPFS.Files
  require Logger

  test "Test file operations syncronously" do
    # Clean up any previous test runs
    assert :ok = Files.rm("/test", recursive: true, force: true)
    {:error, api_error} = Files.ls("/test")
    assert api_error.message == "file does not exist"

    # Test mkdir
    {:error, api_error} = Files.mkdir("/test/illegal")
    assert api_error.message == "file does not exist"
    assert :ok = Files.mkdir("/test/illegal/bar/baz", parents: true)

    # Test ls
    {:ok, files} = Files.ls("/")
    assert is_list(files)
    assert Enum.member?(files, "test")
    # Long listing
    {:ok, %ExIPFS.FilesEntries{}} = Files.ls("/", l: true)

    # Test file operations
    assert :ok = Files.write("👍", "/test/👍.txt", create: true)
    assert :ok = Files.cp("/test/👍.txt", "/test/spaced 👍.txt")
    assert :ok = Files.mv("/test/spaced 👍.txt", "/test/👍.txt")
    assert :ok = Files.rm("/test/👍.txt")
  end
end
