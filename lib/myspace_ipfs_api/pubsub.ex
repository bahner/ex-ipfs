defmodule MyspaceIPFS.Api.PubSub do
    @moduledoc """
  MyspaceIPFS.Api.PubSub is where the pubsub commands of the IPFS API reside.
  """

  def pubsub_ls, do: request_get("/pubsub/ls")

  def pubsub_peers, do: request_get("/pubsub/pub")

  def pubsub_pub(topic, data), do: request_get("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)

  def pubsub_sub(topic), do: request_get("/pubsub/sub?arg=", topic)

end
