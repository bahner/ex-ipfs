defmodule ExIPFS.PubSub.ChannelMessage do
  @moduledoc false

  require Logger

  @enforce_keys [:from, :data, :seqno, :topic_ids]
  defstruct from: nil, data: nil, seqno: nil, topic_ids: nil

  @type t :: %__MODULE__{
          from: binary,
          data: binary,
          seqno: binary,
          topic_ids: list
        }

  # Sample message:
  # {"from":"12D3KooWS9Wzyr6CprW7mZUdushaHvSFf2XGvPhtoBonUYabFECo","data":"uSGVpCg","seqno":"uF0CyYs8EKiE","topicIDs":["uYmFobmVy"]

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    Logger.debug("Creating message form(#{inspect(opts)})")

    %__MODULE__{
      from: opts["from"],
      data: opts["data"],
      seqno: opts["seqno"],
      topic_ids: opts["TopicIDs"]
    }
  end

  @spec new({:ok, map}) :: t()
  def new({:ok, opts}) when is_map(opts) do
    Logger.debug("PubSub.ChannelMessage.new/map(#{inspect(opts)})")
    new(opts)
  end

  @spec new(list) :: list(t())
  def new(response) when is_list(response) do
    Logger.debug("PubSub.ChannelMessage.new/list(#{inspect(response)})")
    Enum.map(response, &new/1)
  end

  @spec new(binary) :: binary()
  def new(response) when is_binary(response) do
    Logger.debug("PubSub.ChannelMessage.new/binary(#{inspect(response)})")
    new(Jason.decode!(response))
  end
end
