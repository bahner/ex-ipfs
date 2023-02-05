defmodule MyspaceIPFS.PubsubTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS.PubSub

  test "subscribe to a topic" do
    {:ok, pid} = PubSub.sub(self(), "myspace")
    assert is_pid(pid)
    assert Process.alive?(pid)
  end

  test "ls" do
    {:ok, %{"Strings" => topics}} = PubSub.ls()
    assert Enum.member?(topics, "myspace")
  end

  test "publish and receive a message" do
    PubSub.sub(self(), "myspace")
    PubSub.pub("hello", "myspace")
    assert_receive {:myspace_ipfs_pubsub_channel_message, "hello"}
  end

  test "peers" do
    {:ok, %{"Strings" => peers}} = PubSub.peers("myspace")

    # The peer list is probably empty, but we can at least check that it is a list.
    assert is_list(peers)
  end
end