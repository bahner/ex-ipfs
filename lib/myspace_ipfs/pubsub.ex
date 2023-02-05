defmodule MyspaceIPFS.PubSub do
  @moduledoc """
  MyspaceIPFS.PubSub is where the pubsub commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.Multibase

  @doc """
  List the topics you are currently subscribed to.
  """
  # FIXME: The stringlist should probably be a struct, which can handle the decoding.
  @spec ls :: {:ok, any} | MyspaceIPFS.ApiError.t()
  def ls do
    post_query("/pubsub/ls")
    |> decode_string_list()
    |> okify()
  end

  # Pull out the string list from the response and decode it.
  # The recreate the map with the decoded list.
  defp decode_string_list(map) when is_map(map) do
    with strings <- map["Strings"] do
      Enum.map(strings, &Multibase.decode!/1)
      |> (fn x -> %{"Strings" => x} end).()
    end
  end

  @doc """
  List the peers you are currently connected to.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-peers
    `topic` - The topic to list peers for.
  """
  @spec peers(binary) :: {:ok, any} | MyspaceIPFS.ApiError.t()
  def peers(topic) do
    base64topic = Multibase.encode(topic)

    post_query("/pubsub/pub/arg?#{base64topic}")
    |> okify()
  end

  @doc """
  Publish a message to a topic.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-pub
  ```
    `topic` - The topic to publish to.
    `data` - The data to publish.
  ```

  ## Usage
  ```
  MyspaceIPFS.PubSub.sub("mymessage", "mytopic")
  ```

  """

  @spec pub(binary, binary) :: {:ok, any} | MyspaceIPFS.ApiError.t()
  def pub(data, topic) do
    with {:ok, base64topic} <- Multibase.encode(topic) do
      multipart_content(data, "data")
      |> post_multipart("/pubsub/pub?arg=" <> base64topic)
      |> okify()
    else
      _ -> {:error, "Could not encode topic"}
    end
  end

  @doc """
  Subscribe to messages on a topic and listen for them.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-sub
    `topic` - The topic to subscribe to.
    `pid`   - The process to send the messages to.
  """
  # FIXME: what does genserver return?
  @spec sub(pid, binary) :: any | MyspaceIPFS.ApiError.t()
  def sub(pid, topic) do
    MyspaceIPFS.PubSubChannel.start_link(pid, topic)
  end
end
