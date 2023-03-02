defmodule ExIpfsPubsub do
  @moduledoc """
  ExIpfsPubsub is where the Pubsub commands of the IPFS API reside.
  """
  import ExIpfs.Api
  import ExIpfs.Utils
  alias ExIpfs.Multibase
  require Logger

  @doc """
  List the topics you are currently subscribed to.

  https://docs.ipfs.io/reference/http/api/#api-v0-Pubsub-ls
  """
  @spec ls :: {:ok, ExIpfs.strings()} | ExIpfs.Api.error_response()
  def ls do
    post_query("/Pubsub/ls")
    |> decode_strings()
    |> ExIpfs.Strings.new()
    |> okify()
  end

  @doc """
  List the peers you are currently connected to.

  https://docs.ipfs.io/reference/http/api/#api-v0-Pubsub-peers

  ## Parameters
    `topic` - The topic to list peers for.
  """
  @spec peers(binary) :: {:ok, any} | ExIpfs.Api.error_response()
  def peers(topic) do
    base64topic = Multibase.encode!(topic)

    post_query("/Pubsub/peers?arg=#{base64topic}")
    |> okify()
  end

  @doc """
  Publish a message to a topic.

  https://docs.ipfs.io/reference/http/api/#api-v0-Pubsub-pub

  ## Parameters
  ```
    `topic` - The topic to publish to.
    `data` - The data to publish.
  ```

  ## Usage
  ```
  ExIpfsPubsub.sub("mymessage", "mytopic")
  ```

  """
  @spec pub(binary, binary) :: {:ok, any} | ExIpfs.Api.error_response()
  def pub(data, topic) do
    multipart_content(data, "data")
    |> post_multipart("/Pubsub/pub?arg=" <> Multibase.encode!(topic))
    |> okify()
  end

  @doc """
  Subscribe to messages on a topic and listen for them.

  https://docs.ipfs.io/reference/http/api/#api-v0-Pubsub-sub

  Messages are sent to the process as a tuple of `{:myspace_ipfs_Pubsub_Topic_message, message}`.
  This should make it easy to pattern match on the messages in a receive do loop.

  ## Parameters
    `topic` - The topic to subscribe to.
    `pid`   - The process to send the messages to.
  """
  @spec sub(pid, binary) :: any | ExIpfs.Api.error_response()
  def sub(pid, topic) do
    ExIpfsPubsub.Topic.new!(pid, topic)
    |> ExIpfsPubsub.Topic.start_link()
  end

  @doc """
  Get next message from the Pubsub Topic in your inbox or wait for one to arrive.

  This is probably just useful for testing and is just here for the sweetness of it.
  https://www.youtube.com/watch?v=6jAVHBLvo2c

  It's just not good for your health, but OK for your soul.
  """
  @spec get_Pubsub_Topic_message :: any
  def get_Pubsub_Topic_message() do
    receive do
      {:myspace_ipfs_Pubsub_Topic_message, message} -> message
    end
  end

  @spec decode_strings({:error, any}) :: {:error, any}
  defp decode_strings({:error, data}), do: {:error, data}

  @spec decode_strings(map) :: map
  defp decode_strings(strings) when is_map(strings) do
    strings = Map.get(strings, "Strings", [])
    decoded_strings = Enum.map(strings, &Multibase.decode!/1)
    %{"Strings" => decoded_strings}
  end

  @spec decode_strings(list) :: list
  defp decode_strings(list), do: Enum.map(list, &decode_strings/1)
end
