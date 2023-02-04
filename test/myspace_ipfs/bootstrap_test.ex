defmodule MyspaceIPFS.BootstrapTest do
  @moduledoc """
  Test the MyspaceIPFS API bootstrap commands

  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS.Bootstrap

  # This is a list of peers I hope are somewhat stable. I don't know how to get a list of stabe peers.
  @test_peers [
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmcZf59bWwK5XFi76CZX8cbJ4BhTzzA3gU1ZjYZcYW3dwt",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmbLHAnMoJPWSCR5Zhtx6BHJX9KiKNN6tpvbUcqanj75Nb",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmQCU2EcMqAqQPR2i9bChDtGNJchTbq5TbXJJ16u19uLTa",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN"
  ]

  defp list_contains_element_that_starts_with?(list, string) do
    Enum.any?(list, fn x -> String.starts_with?(x, string) end)
  end

  defp element_is_peers?({:ok, element}) do
    %MyspaceIPFS.Peers{} = element
  end

  test "List should return representative data" do
    {:ok, bootstrap} = Bootstrap.list()
    assert is_map(bootstrap)
    assert %MyspaceIPFS.Peers{} = bootstrap
    assert is_list(bootstrap.peers)
    assert list_contains_element_that_starts_with?(bootstrap.peers, "/ip4/")

    assert list_contains_element_that_starts_with?(
             bootstrap.peers,
             "/dnsaddr/bootstrap.libp2p.io/p2p/"
           )
  end

  # Testing a list of peers implicitly tests adding one peer.
  test "Put list of peers shold work" do
    {:ok, boostrap} = Bootstrap.add(@test_peers)
    assert is_list(boostrap)
    assert Enum.all?(boostrap, &element_is_peers?/1)
  end

  # Testing a list of peers implicitly tests adding one peer.
  test "Put list of default peers shold work" do
    {:ok, boostrap} = Bootstrap.add_default(@test_peers)
    assert is_list(boostrap)
    assert Enum.all?(boostrap, &element_is_peers?/1)
  end

  test "test add a misnamed peer without /" do
    {:error, boostrap} = Bootstrap.add("foo")
    assert %MyspaceIPFS.ApiError{} = boostrap
    assert boostrap.message == "failed to parse multiaddr \"foo\": must begin with /"
  end

  test "test add default a misnamed peer without /" do
    {:error, boostrap} = Bootstrap.add_default("foo")
    assert %MyspaceIPFS.ApiError{} = boostrap
    assert boostrap.message == "failed to parse multiaddr \"foo\": must begin with /"
  end

  test "test add a misnamed peer without protocol" do
    {:error, boostrap} = Bootstrap.add("/foo")
    assert %MyspaceIPFS.ApiError{} = boostrap
    assert boostrap.message == "failed to parse multiaddr \"/foo\": unknown protocol foo"
  end

  test "test add default a misnamed peer without protocol" do
    {:error, boostrap} = Bootstrap.add_default("/foo")
    assert %MyspaceIPFS.ApiError{} = boostrap
    assert boostrap.message == "failed to parse multiaddr \"/foo\": unknown protocol foo"
  end

  test "test add an incomplete peer" do
    {:error, boostrap} = Bootstrap.add("/dnsaddr/bootstrap.libp2p.io/p2p")
    assert %MyspaceIPFS.ApiError{} = boostrap

    assert boostrap.message ==
             "failed to parse multiaddr \"/dnsaddr/bootstrap.libp2p.io/p2p\": unexpected end of multiaddr"
  end

  test "test add default an incomplete peer" do
    {:error, boostrap} = Bootstrap.add_default("/dnsaddr/bootstrap.libp2p.io/p2p")
    assert %MyspaceIPFS.ApiError{} = boostrap

    assert boostrap.message ==
             "failed to parse multiaddr \"/dnsaddr/bootstrap.libp2p.io/p2p\": unexpected end of multiaddr"
  end

  # NB! Testing rm amd rm_all would be destructive. I don't want to do that.
  # They do work, as I have repeatedly tested inadverdently.
end
