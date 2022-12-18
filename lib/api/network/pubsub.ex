defmodule MyspaceIPFS.Api.Network.PubSub do
  @moduledoc """
  MyspaceIPFS.Api.PubSub is where the pubsub commands of the IPFS API reside.
  """
  import MyspaceIPFS

  @spec ls :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def ls, do: post_query("/pubsub/ls")

  @spec peers :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def peers, do: post_query("/pubsub/pub")

  @spec pub(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def pub(topic, data),
    do: post_query("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)

  @spec sub(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def sub(topic), do: post_query("/pubsub/sub?arg=", topic)
end
