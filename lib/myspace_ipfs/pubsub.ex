defmodule MyspaceIpfs.PubSub do
  @moduledoc """
  MyspaceIpfs.PubSub is where the pubsub commands of the IPFS API reside.
  """
  import MyspaceIpfs.Api
  import MyspaceIpfs.Utils
  alias MyspaceIpfs.Multibase
  alias Tesla.Multipart

  @typep okresult :: MyspaceIpfs.okresult()
  @typep name :: MyspaceIpfs.name()

  @doc """
  List the topics you are currently subscribed to.
  """
  @spec ls :: okresult
  def ls do
    post_query("/pubsub/ls")
    |> handle_api_response()
    |> okify()
  end

  @doc """
  List the topics you are currently subscribed to
  and decode the base64 encoded topic names, if needed.
  """
  @spec ls(:decode) :: okresult
  def ls(:decode) do
    post_query("/pubsub/ls")
    |> handle_api_response()
    |> okify()

    # FIXME: Next step is to fix the response handling
    # |> decode_response()
  end

  @doc """
  List the peers you are currently connected to.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-peers
    `topic` - The topic to list peers for.
  """
  @spec peers(binary) :: okresult
  def peers(topic) do
    base64topic = Multibase.encode(topic)

    post_query("/pubsub/pub/arg?#{base64topic}")
    |> handle_api_response()
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
  MyspaceIpfs.PubSub.sub("mymessage", "mytopic")
  ```

  """
  @spec pub(binary, name) :: okresult
  def pub(data, topic) do
    {:ok, base64topic} = Multibase.encode(topic)

    Multipart.new()
    |> Multipart.add_field("data", data)
    |> post_multipart("/pubsub/pub?arg=#{base64topic}")
  end

  @doc """
  Subscribe to messages on a topic and listen for them.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-sub
    `topic` - The topic to subscribe to.
    `pid`   - The process to send the messages to.
  """
  @spec sub(pid, binary) :: any
  def sub(pid, topic) do
    MyspaceIpfs.PubSubChannel.start_link(pid, topic)
  end
end
