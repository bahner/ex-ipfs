defmodule MyspaceIPFS.PubSub do
  @moduledoc """
  MyspaceIPFS.PubSub is where the pubsub commands of the IPFS API reside.
  """
  import MyspaceIPFS.Api

  def ls, do: post_query("/pubsub/ls")

  def peers, do: post_query("/pubsub/pub")

  def pub(topic, data),
    do: post_query("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)

  def sub(topic), do: post_query("/pubsub/sub?arg=" <> topic)
end
