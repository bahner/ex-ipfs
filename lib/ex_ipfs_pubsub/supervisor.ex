defmodule ExIpfsPubsub.Supervisor do
  @moduledoc """
  Supervisor keeping a Topic alive.
  """
  use Supervisor
  require Logger

  @spec start_link(list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    Supervisor.init([], strategy: :one_for_one)
  end

  @spec add_child(Supervisor.child_spec()) :: Supervisor.on_start()
  def add_child(child_spec) do
    Supervisor.start_child(__MODULE__, child_spec)
  end

  @spec new!(ExIpfsPubsub.Topic.t(), keyword()) :: Supervisor.child_spec()
  def new!(Topic, options \\ []) when is_struct(Topic) do
    Topic = ExIpfsPubsub.Topic.new!(Topic.target(), Topic.topic())

    child_spec(%{
      id: Topic.topic(),
      start: {ExIpfsPubsub.Topic, :start_link, Topic, options}
    })
  end
end
