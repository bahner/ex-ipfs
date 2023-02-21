defmodule ExIPFS.PubSub.ChannelSupervisor do
  @moduledoc """
  The ExObject.Supervisor is a supervisor for a colletion of ExObject.
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

  @spec new!(ExIPFS.PubSub.Channel.t(), keyword()) :: Supervisor.child_spec()
  def new!(channel, options \\ []) when is_struct(channel) do
    channel = ExIPFS.PubSub.Channel.new!(channel.target, channel.topic)

    child_spec(%{
      id: channel.topic,
      start: {ExIPFS.PubSub.Channel, :start_link, channel, options}
    })
  end
end
