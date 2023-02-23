defmodule ExIpfsTest do
  @moduledoc """
  Test the ExIpfs module

  This test suite is designed to test the ExIpfs API. It is not designed to test the IPFS API
  itself. It is designed to test the ExIpfs API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node.
  """
  alias ExUnit.DocTest

  use ExUnit.Case, async: false

  ExUnit.configure(seed: 0)

  test "resolve should return an error, when dnslink is missing" do
    {:error, response} = ExIpfs.resolve("/ipns/ipns.foo")

    assert %ExIpfs.ApiError{} = response

    assert response.message ==
             "could not resolve name: \"ipns.foo\" is missing a DNSLink record (https://docs.ipfs.io/concepts/dnslink/)"

    assert response.code == 0
    assert response.type == "error"
  end

  test "resolve should return a map with a path key" do
    {:ok, response} = ExIpfs.resolve("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    assert is_map(response)
    assert is_binary(Map.fetch!(response, "Path"))
  end

  test "ls should return a list of objects" do
    {:ok, response} = ExIpfs.ls("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    %ExIpfs.Objects{} = response
    %ExIpfs.ObjectLinks{} = List.first(response.objects)
    object = List.first(response.objects)
    assert is_binary(object.hash)
    assert object.hash == "Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z"
    assert is_list(object.links)
  end

  test "add a file to IPFS" do
    {:ok, response} = ExIpfs.add("TODO")

    assert is_map(response)
    assert is_binary(response.hash)
    assert is_binary(response.name)
    assert is_binary(response.size)
    assert is_integer(response.bytes)
  end

  test "cat hello world Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z" do
    response = ExIpfs.cat("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    assert is_binary(response)
    assert response == "Hello World!\r\n"
  end

  test "get hello world" do
    File.rm_rf!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    {:ok, "Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z"} =
      ExIpfs.get("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    assert File.exists?("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
    stat = File.stat!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
    assert stat.size == 14
    File.rm_rf!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
  end

  test "get as archive hello world" do
    File.rm_rf!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")

    {:ok, "Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z"} =
      ExIpfs.get("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z", archive: true)

    assert File.exists?("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
    stat = File.stat!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
    File.rm_rf!("Qmc5gCcjYypU7y28oCALwfSvxCBskLuPKWpK4qpterKC7z")
  end

  test "Get the ID of the local ipfs daemon" do
    {:ok, response} = ExIpfs.id()

    assert %ExIpfs.Id{} = response
    assert is_binary(response.agent_version)
    assert is_binary(response.id)
    assert is_binary(response.protocol_version)
    assert is_binary(response.public_key)
    assert is_list(response.addresses)
    assert is_list(response.protocols)
  end

  test "add_fspath adds a file to a multipart body" do
    Temp.track!()
    {_pid, file} = Temp.open!("add_fspath")
    assert {:ok, %ExIpfs.AddResult{}} = ExIpfs.add_fspath(file)
    assert {:ok, added} = ExIpfs.add_fspath(file)
    assert added.name == Path.basename(file)
  end

  test "add_fspath adds a directory to a multipart body" do
    Temp.track!()
    dir = Temp.mkdir!("add_fspath")
    File.write(Path.join(dir, "add_fspath"), "some content")
    assert {:ok, added} = ExIpfs.add_fspath(dir)
    assert is_list(added)
    assert %ExIpfs.AddResult{} = List.first(added)
  end

  test "test bases returns a list of valid bases" do
    {:ok, bases} = ExIpfs.Cid.bases()
    assert is_list(bases)
    assert %ExIpfs.MultibaseEncoding{} = List.first(bases)
    assert find_base_code("base58btc") == 122
    assert find_base_code("identity") == 0
  end

  defp find_base_code(name) do
    {:ok, bases} = ExIpfs.Cid.bases()
    base = Enum.find(bases, fn base -> base.name == name end)
    base.code
  end
end
