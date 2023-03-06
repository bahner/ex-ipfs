defmodule ExIpfsPubsub.Registry do
  @moduledoc false

  use GenServer

  # API

  @spec start_link :: :ignore | {:error, any} | {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, nil)
  end

  @spec whereis_name(binary) :: any
  def whereis_name(topic) do
    GenServer.call(__MODULE__, {:whereis_name, topic})
  end

  @spec register_name(binary, pid) :: any
  def register_name(topic, pid) do
    GenServer.call(__MODULE__, {:register_name, topic, pid})
  end

  @spec unregister_name(binary) :: :ok
  def unregister_name(topic) do
    GenServer.cast(__MODULE__, {:unregister_name, topic})
  end

  @spec send(binary, any) :: atom | pid | port | reference | {atom, atom | {binary, any}}
  def send(topic, message) do
    case whereis_name(topic) do
      :undefined ->
        {:badarg, {topic, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  @spec init(any) :: {:ok, %{}}
  def init(_) do
    {:ok, Map.new()}
  end

  def handle_call({:whereis_name, topic}, _from, state) do
    {:reply, Map.get(state, topic, :undefined), state}
  end

  def handle_call({:register_name, topic, pid}, _from, state) do
    case Map.get(state, topic) do
      nil ->
        {:reply, :yes, Map.put(state, topic, pid)}

      _ ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, topic}, state) do
    {:noreply, Map.delete(state, topic)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, remove_pid(state, pid)}
  end

  defp remove_pid(state, pid_to_remove) do
    remove = fn {_key, pid} -> pid != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end
end
