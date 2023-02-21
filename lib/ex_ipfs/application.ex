defmodule ExIPFS.Application do
  @moduledoc """
  The ExObject.Application is the main application for ExObject.
  """
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      # Start the PubSub Channel Supervisor, with module name as visible name.
      {ExIPFS.PubSub.ChannelSupervisor, name: ExIPFS.PubSub.ChannelSupervisor}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
