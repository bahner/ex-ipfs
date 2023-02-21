defmodule ExIPFS.DhtQueryResponse do
  @moduledoc false
  require Logger
  import ExIPFS.Utils, only: [filter_empties: 1]

  defstruct extra: nil, id: nil, responses: [], type: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: ExIPFS.Dht.query_response()
  def new(attrs) when is_map(attrs) do
    Logger.debug("DhtQueryResponse.new(#{inspect(attrs)})")

    %__MODULE__{
      extra: attrs["Extra"],
      id: attrs["ID"],
      responses: handle_responses(attrs),
      type: attrs["Type"]
    }
  end

  @spec new(list) :: list(ExIPFS.Dht.query_response())
  def new(response) when is_list(response) do
    Logger.debug("DhtQueryResponseList.new(#{inspect(response)})")

    response
    |> filter_empties()
    |> Enum.map(&new/1)
  end

  @spec new(binary) :: binary()
  def new(response) when is_binary(response), do: response

  @spec handle_responses(map) :: list(ExIPFS.Dht.query_response_addrs()) | []
  defp handle_responses(attrs) when is_map(attrs) do
    attrs = Map.get(attrs, "Responses", nil)

    case attrs do
      nil -> nil
      _ -> Enum.map(attrs, &ExIPFS.DhtQueryResponseAddrs.new/1)
    end
  end
end
