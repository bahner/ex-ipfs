defmodule MyspaceIPFS.PubSub do
  @moduledoc """
  MyspaceIPFS.PubSub is where the pubsub commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.Multibase

  @doc """
  List the topics you are currently subscribed to.

  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-ls
  """
  @spec ls :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def ls do
    post_query("/pubsub/ls")
    |> decode_string_list()
    |> okify()
  end

  @doc """
  List the peers you are currently connected to.

  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-peers

  ## Parameters
    `topic` - The topic to list peers for.
  """
  @spec peers(binary) :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def peers(topic) do
    base64topic = Multibase.encode!(topic)

    post_query("/pubsub/peers?arg=#{base64topic}")
    |> okify()
  end

  @doc """
  Publish a message to a topic.

  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-pub

  ## Parameters
  ```
    `topic` - The topic to publish to.
    `data` - The data to publish.
  ```

  ## Usage
  ```
  MyspaceIPFS.PubSub.sub("mymessage", "mytopic")
  ```

  """
  @spec pub(binary, binary) :: {:ok, any} | MyspaceIPFS.Api.error_response()
  def pub(data, topic) do
    multipart_content(data, "data")
    |> post_multipart("/pubsub/pub?arg=" <> Multibase.encode!(topic))
    |> okify()
  end

  @doc """
  Subscribe to messages on a topic and listen for them.

  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-sub

  Messages are sent to the process as a tuple of `{:myspace_ipfs_pubsub_channel_message, message}`.
  This should make it easy to pattern match on the messages in a receive do loop.

  ## Parameters
    `topic` - The topic to subscribe to.
    `pid`   - The process to send the messages to.
  """
  @spec sub(pid, binary) :: any | MyspaceIPFS.Api.error_response()
  def sub(pid, topic) do
    MyspaceIPFS.PubSubChannel.start_link(pid, topic)
  end

  @doc """
  Get next message from the pubsub channel in your inbox or wait for one to arrive.

  This is probably just useful for testing and is just here for the sweetness of it.
  https://www.youtube.com/watch?v=6jAVHBLvo2c

  It's just not good for your health, but OK for your soul.
  """
  @spec get_pubsub_channel_message :: any
  def get_pubsub_channel_message() do
    receive do
      {:myspace_ipfs_pubsub_channel_message, message} -> message
    end
  end

  # Pull out the string list from the response and decode it.
  # The recreate the map with the decoded list.
  defp decode_string_list(map) when is_map(map) do
    with strings <- map["Strings"] do
      Enum.map(strings, &Multibase.decode!/1)
      |> (fn x -> %{"Strings" => x} end).()
    end
  end
end
