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
    |> decode_response()
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
  """
  @spec sub(binary) :: any
  def sub(topic) do
    # Topics must be base64 encoded.
    with {:ok, base64topic} <- encode(topic),
         opts <- [recv_timeout: :infinity],
         {:ok, _, _, ref} =
           :hackney.request(
             "post",
             "http://localhost:5001/api/v0/pubsub/sub?arg=#{base64topic}",
             [],
             <<>>,
             opts
           ) do
      loop(ref)
    end
  end

  # This loop automagically understands newlines,
  # so we don't need to worry about that.
  # The upshot is that when we receive a line, we just
  # wait for the next one.
  defp loop(ref) do
    parse_response(:hackney.stream_body(ref))
    loop(ref)
  end

  # Some, but not all responses are base64 encoded,
  # so we need to try to decode them.
  defp decode_if_needed(value) do
    case decode(value) do
      {:ok, decoded} -> decoded
      _ -> value
    end
  end

  # Each line is actually a JSON object, so we need to
  # to extract the data from it. I donæt believe the rest
  # of the data is useful to us.
  # Feature request if it is to you!
  defp parse_response(response) do
    with {:ok, body} <- response,
         {:ok, json} <- Jason.decode(body) do
      value = json["data"]
      text = decode(value)
      IO.inspect(text)
    end
  end

  defp decode_response(response) do
    with {:ok, response} <- response,
         {:ok, list} <- Map.fetch(response, "Strings") do
      list
      |> Enum.map(&decode_if_needed(&1))
      |> recreate_map()
      |> okify()
    end
  end

  defp recreate_map(map) do
    %{
      "Strings" => map
    }
  end
end
