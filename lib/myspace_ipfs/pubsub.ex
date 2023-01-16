defmodule MyspaceIPFS.PubSub do
  @moduledoc """
  MyspaceIPFS.PubSub is where the pubsub commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api
  import MyspaceIPFS.Utils
  alias MyspaceIPFS.Multibase

  @typep okresult :: MyspaceIPFS.okresult()
  @typep name :: MyspaceIPFS.name()

  @doc """
  Cancel a subscription to a topic.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-cancel
    `topic` - The topic to cancel the subscription to.
  """
  @spec cancel(atom) :: okresult
  def cancel(topic) do
    post_query("/pubsub/cancel?arg=#{topic}")
    |> handle_json_response()
  end

  @doc """
  List the topics you are currently subscribed to.
  """
  @spec ls :: okresult
  def ls do
    post_query("/pubsub/ls")
    |> handle_json_response()
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
    post_query("/pubsub/pub?arg=#{topic}&arg=#{data}")
    |> handle_json_response()
  end

  @doc """
  Show the current pubsub state.
  """
  @spec state :: okresult
  def state do
    post_query("/pubsub/state")
    |> handle_json_response()
  end

  @doc """
  Subscribe to messages on a topic and listen for them.

  ## Parameters
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-sub
    `topic` - The topic to subscribe to.
  """
  @spec sub(binary) :: any
  def sub(topic) do
    with {:ok, base64topic} <- Multibase.encode(topic) do
     post_query_infinity("/pubsub/sub?arg=#{base64topic}")
    end
  end

  defp body(ref) do
    parse_response(:hackney.stream_body(ref))
    body(ref)
  end

  def hack(topic) do
    with {:ok, base64topic} <- Multibase.encode(topic),
    opts <- [recv_timeout: :infinity],
    {:ok, _, _, ref} = :hackney.request("post", "http://localhost:5001/api/v0/pubsub/sub?arg=#{base64topic}", [], <<>>, opts)
    do
      body(ref)
    end
  end

  defp parse_response(response) do
    with {:ok, body} <- response,
    {:ok, json} <- Jason.decode(body) do
      value = json["data"]
      text = Multibase.decode(value)
      IO.inspect(text)
    end
  end

  @doc """
  List the subscriptions you have.

  ## Options
  https://docs.ipfs.io/reference/http/api/#api-v0-pubsub-subs
    `ipns-base` - Base used for keys.
  """
  @spec subs :: okresult
  def subs do
    post_query("/pubsub/subs")
    |> handle_json_response()
  end
end
