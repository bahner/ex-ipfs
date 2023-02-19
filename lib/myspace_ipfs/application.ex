defmodule MyspaceIPFS.Application do
  @moduledoc """
  The MyspaceObject.Application is the main application for MyspaceObject.
  """
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      # Start the PubSub Channel Supervisor, with module name as visible name.
      {MyspaceIPFS.PubSub.ChannelSupervisor, name: MyspaceIPFS.PubSub.ChannelSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
