defmodule ExIpfs.PingReply do
  @moduledoc false

  defstruct success: nil, time: nil, text: nil

  @type t :: %__MODULE__{
          success: boolean,
          time: non_neg_integer,
          text: binary
        }

  @spec new(map) :: t | {:error, any}
  def new(reply) when is_map(reply) do
    %__MODULE__{
      success: Map.get(reply, "Success", nil),
      time: Map.get(reply, "Time", nil),
      text: Map.get(reply, "Text", nil)
    }
  end

  def new(data) do
    case data do
      {:error, reply} -> {:error, reply}
      _ -> {:error, "Invalid response"}
    end
  end
end
