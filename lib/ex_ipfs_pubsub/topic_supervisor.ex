defmodule ExIpfsPubsub.Supervisor do
  @moduledoc false

  use Supervisor, restart: :transient
  require Logger

  @typep topic :: ExIpfsPubsub.Topic.t()

  @spec start_link(list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @spec init(any) :: none
  def init(_init_arg) do
    children = {ExIpfsPubsub.Topic, []}
    Supervisor.init(children, strategy: :simple_one_for_one)
  end

  @spec start_topic(topic) :: Supervisor.on_start_child()
  def start_topic(topic) when is_struct(topic) do
    Supervisor.start_child(__MODULE__, topic)
  end
end
