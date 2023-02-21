defmodule ExIPFS.PubsubTest do
  @moduledoc """
  Test the ExIPFS API

  This test suite is designed to test the ExIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the ExIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  @timeout 180_000
  use ExUnit.Case, async: true
  @moduletag timeout: @timeout
  ExUnit.configure(seed: 0, timeout: @timeout)
  alias ExIPFS.PubSub

  test "subscribe to a topic" do
    {:ok, pid} = PubSub.sub(self(), "ex")
    assert is_pid(pid)
    assert Process.alive?(pid)

    # ls
    PubSub.sub(self(), "ex")
    {:ok, %ExIPFS.Strings{strings: topics}} = PubSub.ls()
    assert is_list(topics)
    assert Enum.member?(topics, "ex")

    # Publish and receive a message
    PubSub.sub(self(), "ex")
    PubSub.pub("hello", "ex")
    assert_receive {:ex_ipfs_pubsub_channel_message, "hello"}

    # Get peers
    {:ok, %{"Strings" => peers}} = PubSub.peers("ex")
    # The peer list is probably empty, but we can at least check that it is a list.
    assert is_list(peers)
  end
end
