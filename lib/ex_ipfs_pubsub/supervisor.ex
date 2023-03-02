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
    Supervisor.start_child(ExIpfsPubsub.Sub, child_spec)
  end

  @spec new_sub_child(atom | %{:topic => any, optional(any) => any}) :: %{
          id: any,
          start: {ExIpfsPubsub.Sub, :start_link, [[...] | {any, any}, ...]}
        }
  def new_sub_child(sub) do
    %{
      id: sub.topic,
      start: {ExIpfsPubsub.Sub, :start_link, [[sub], name: sub.topic]}
    }
  end
end
