defmodule ExIpfsPubsubTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  @timeout 180_000

  import ExIpfsPubsub
  @topic Nanoid.generate()

  test "subscribe to a topic" do
    {:ok, pid} = sub(self(), @topic)
    assert is_pid(pid)
    assert Process.alive?(pid)

    # ls
    sub(self(), @topic)
    {:ok, topics} = ls()
    assert is_list(topics)
    assert Enum.member?(topics, @topic)

    # Publish and receive a message
    sub(self(), @topic)
    pub("hello", @topic)
    assert_receive {:ex_ipfs_pubsub_sub_message, "hello"}

    # Get peers. Probably an empty file.
    {:ok, peerslist} = peers(@topic)
    assert is_list(peerslist)
  end
end
