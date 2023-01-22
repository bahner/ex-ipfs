defmodule MyspaceIPFS.PubSub do
  @moduledoc """
  MyspaceIPFS.PubSub is where the pubsub commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  import MyspaceIPFS.Multibase

  @typep okresult :: MyspaceIPFS.okresult()
  @typep name :: MyspaceIPFS.name()

  @doc """
  List the topics you are currently subscribed to.
  """
  @spec ls :: okresult
  def ls do
    post_query("/pubsub/ls")
    |> handle_json_response()
  end

  @doc """
  List the topics you are currently subscribed to
  and decode the base64 encoded topic names, if needed.
  """
  @spec ls(:decode) :: okresult
  def ls(:decode) do
    post_query("/pubsub/ls")
    |> handle_json_response()

    # FIXME: Next step is to fix the response handling
    # |> decode_response()
  end

  @doc """
  List the peers you are currently connected to.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-peers
    `topic` - The topic to list peers for.
  """
  @spec peers(atom) :: okresult
  def peers(topic) do
    post_query("/pubsub/pub/arg?#{topic}")
    |> handle_json_response()
  end

  @doc """
  Publish a message to a topic.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-pub
    `topic` - The topic to publish to.
    `data` - The data to publish.
  """
  @spec pub(name, name) :: okresult
  def pub(topic, data) do
    with {:ok, base64topic} <- encode(topic) do
      post_data("/pubsub/pub?arg=#{base64topic}", data)
      |> handle_json_response()
    end
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
    MyspaceIPFS.PubSub.Channel.start_link(pid, topic)
  end
end
