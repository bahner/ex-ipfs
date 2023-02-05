defmodule MyspaceIPFS.PubSubChannelMessage do
  @moduledoc false
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

  def new({:error, data}), do: {:error, data}
  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      from: opts["from"],
      data: opts["data"],
      seqno: opts["seqno"],
      topic_ids: opts["TopicIDs"]
    }
  end

  @spec new({:ok, map}) :: t()
  def new({:ok, opts}) when is_map(opts) do
    new(opts)
  end
end
