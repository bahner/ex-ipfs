defmodule ExIpfsPubsub.Topics do
  @moduledoc false

  use Agent

  require Logger

  @typep topic :: ExIpfsPubsub.Topic.t()

  @spec start_link(list) :: {:error, any} | {:ok, pid}
  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec put(topic) :: :ok
  def put(topic) do
    Agent.update(__MODULE__, &Map.put(&1, topic.topic, topic))
  end

  @spec get(binary) :: topic | nil
  def get(key) do
    topic = Agent.get(__MODULE__, &Map.get(&1, key))

    case topic do
      nil -> nil
      _ -> sanitize_topic(topic)
    end
  end

  @spec delete(binary | topic) :: :ok
  def delete(key) when is_binary(key) do
    Agent.update(__MODULE__, &Map.delete(&1, key))
  end

  @spec all_values :: list(topic)
  def all_values do
    Agent.get(__MODULE__, &Map.values(&1))
  end

  @spec all_topics :: list
  def all_topics do
    Agent.get(__MODULE__, &Map.keys(&1))
  end

  @spec add_subscriber(pid, binary) :: :ok
  def add_subscriber(subscriber, topic) when is_binary(topic) and is_pid(subscriber) do
    Agent.update(__MODULE__, fn topics ->
      topic = Map.get(topics, topic)

      if topic do
        Logger.debug("Adding subscriber #{subscriber} to topic #{topic.topic}")

        Map.put(
          topics,
          topic.topic,
          MapSet.put(topic, subscribers: [subscriber | topic.subscribers])
        )
      else
        Logger.warn("Topic #{topic} does not exist")

        topics
      end
    end)
  end

  @spec is_subscribed?(pid, binary) :: boolean
  def is_subscribed?(subscriber, topic) when is_binary(topic) and is_pid(subscriber) do
    topic = Agent.get(__MODULE__, &Map.get(&1, topic))

    if topic do
      Enum.member?(topic.subscribers, subscriber)
    else
      false
    end
  end

  @spec remove_subscriber(pid, binary) :: :ok
  def remove_subscriber(subscriber, topic) when is_binary(topic) and is_pid(subscriber) do
    Agent.update(__MODULE__, fn topics ->
      topic = Map.get(topics, topic)

      if topic do
        Logger.debug("Removing subscriber #{subscriber} from topic #{topic.topic}")

        Map.put(
          topics,
          topic.topic,
          Map.put(topic, :subscribers, List.delete(topic.subscribers, subscriber))
        )
      else
        Logger.warn("Topic #{topic} does not exist")

        topics
      end
    end)
  end

  # This functions checks if the handler and subscribers are still alive
  @spec sanitize_topic(topic) :: topic
  defp sanitize_topic(topic) do
    topic = topic |> Map.put(:subscribers, Enum.filter(topic.subscribers, &Process.alive?/1))
    handler = if Process.alive?(topic.handler), do: topic.handler, else: nil
    topic |> Map.put(:handler, handler)
  end
end
