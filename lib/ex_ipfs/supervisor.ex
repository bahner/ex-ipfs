defmodule ExIpfs.Supervisor do
  @moduledoc false

  use Supervisor
  require Logger

  @spec start_link(list) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = []

    Supervisor.init(children, strategy: :one_for_one)
  end
end
