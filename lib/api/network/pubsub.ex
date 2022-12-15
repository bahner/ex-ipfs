defmodule MyspaceIPFS.Api.Network.PubSub do
  @moduledoc """
  MyspaceIPFS.Api.PubSub is where the pubsub commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils

  @spec ls :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def ls, do: request_get("/pubsub/ls")

  @spec peers :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def peers, do: request_get("/pubsub/pub")

  @spec pub(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def pub(topic, data),
    do: request_get("/pubsub/pub?arg=" <> topic <> "&arg=" <> data)

  @spec sub(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def sub(topic), do: request_get("/pubsub/sub?arg=", topic)
end
