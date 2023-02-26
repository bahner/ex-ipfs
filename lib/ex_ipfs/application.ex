defmodule ExIpfs.Application do
  @moduledoc false
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      {ExIpfs.Supervisor, name: ExIpfs.Supervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
