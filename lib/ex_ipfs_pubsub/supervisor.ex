defmodule ExIpfsPubsub.Supervisor do
  @moduledoc false

  use Supervisor, restart: :transient
  require Logger

  @spec start_link(list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @spec init(any) :: Supervisor.on_start_child()
  def init(_init_arg) do
    children = [ExIpfsPubsub.Topics]

    Supervisor.init(children, strategy: :one_for_one)
  end

  @spec supervise_topic(ExIpfsPubsub.Topic.t()) :: Supervisor.on_start_child()
  def supervise_topic(sub) when is_struct(sub) do
    topic = %{id: sub.topic, start: {ExIpfsPubsub.Topic, :start_link, [sub]}}
    # topic = {ExIpfsPubsub.Topic, sub}

    Supervisor.start_child(__MODULE__, topic)
  end
end
