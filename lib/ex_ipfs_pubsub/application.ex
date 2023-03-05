defmodule ExIpfsPubsub.Application do
  @moduledoc false
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {ExIpfsPubsub.Supervisor, name: ExIpfsPubsub.Supervisor},
      {Registry, keys: :unique, name: ExIpfsPubsub.TopicRegistry}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
