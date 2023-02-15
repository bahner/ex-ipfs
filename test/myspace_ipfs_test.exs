defmodule MyspaceIPFSTest do
  @moduledoc """
  Test the MyspaceIPFS module

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node.
  """
  use ExUnit.Case, async: false
  ExUnit.configure(seed: 0)

  test "resolve should return an error, when dnslink is missing" do
    {:error, response} = MyspaceIPFS.resolve("/ipns/ipns.foo")

    assert %MyspaceIPFS.ApiError{} = response

    assert response.message ==
             "could not resolve name: \"ipns.foo\" is missing a DNSLink record (https://docs.ipfs.io/concepts/dnslink/)"

    assert response.code == 0
    assert response.type == "error"
  end

  test "resolve should return a map with a path key" do
    {:ok, response} = MyspaceIPFS.resolve("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    assert is_map(response)
    assert is_binary(Map.fetch!(response, "Path"))
  end

  test "ls should return a list of objects" do
    {:ok, response} = MyspaceIPFS.ls("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    %MyspaceIPFS.Objects{} = response
    %MyspaceIPFS.HashLinks{} = List.first(response.objects)
    object = List.first(response.objects)
    assert is_binary(object.hash)
    assert object.hash == "Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z"
    assert is_list(object.links)
  end

  test "add a file to IPFS" do
    {:ok, response} = MyspaceIPFS.add("TODO")

    assert is_map(response)
    assert is_binary(response.hash)
    assert is_binary(response.name)
    assert is_binary(response.size)
    assert is_integer(response.bytes)
  end

  test "cat hello world Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z" do
    response = MyspaceIPFS.cat("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    assert is_binary(response)
    assert response == "Hello World!\r\n"
  end

  test "get hello world" do
    File.rm!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    {:ok, "Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z"} =
      MyspaceIPFS.get("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    assert File.exists?("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
    stat = File.stat!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
    assert stat.size == 14
  end

  test "Get the ID of the local ipfs daemon" do
    {:ok, response} = MyspaceIPFS.id()

    assert %MyspaceIPFS.Id{} = response
    assert is_binary(response.agent_version)
    assert is_binary(response.id)
    assert is_binary(response.protocol_version)
    assert is_binary(response.public_key)
    assert is_list(response.addresses)
    assert is_list(response.protocols)
  end
end
