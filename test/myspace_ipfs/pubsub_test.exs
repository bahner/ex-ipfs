defmodule MyspaceIPFS.PubsubTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  @timeout 180_000
  use ExUnit.Case, async: true
  @moduletag timeout: @timeout
  ExUnit.configure(seed: 0, timeout: @timeout)
  alias MyspaceIPFS.PubSub

  test "subscribe to a topic" do
    {:ok, pid} = PubSub.sub(self(), "myspace")
    assert is_pid(pid)
    assert Process.alive?(pid)

    # ls
    PubSub.sub(self(), "myspace")
    {:ok, %MyspaceIPFS.Strings{strings: topics}} = PubSub.ls()
    assert is_list(topics)
    assert Enum.member?(topics, "myspace")

    # Publish and receive a message
    PubSub.sub(self(), "myspace")
    PubSub.pub("hello", "myspace")
    assert_receive {:myspace_ipfs_pubsub_channel_message, "hello"}

    # Get peers
    {:ok, %{"Strings" => peers}} = PubSub.peers("myspace")
    # The peer list is probably empty, but we can at least check that it is a list.
    assert is_list(peers)
  end
end
