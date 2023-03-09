defmodule ExIpfsPubsub.Application do
  @moduledoc false
  use Application

  @registry ExIpfsPubsub.Registry

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {ExIpfsPubsub.Supervisor, name: ExIpfsPubsub.Supervisor},
      {Registry, [keys: :unique, name: @registry]}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
