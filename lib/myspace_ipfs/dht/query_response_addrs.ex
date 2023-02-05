defmodule MyspaceIPFS.DhtQueryResponseAddrs do
  @moduledoc false
  require Logger

  @enforce_keys [:addrs, :id]
  defstruct addrs: [], id: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.Dht.query_response_addrs()
  def new(attrs) when is_map(attrs) do
    %__MODULE__{
      addrs: attrs["Addrs"],
      id: attrs["ID"]
    }
  end

  @spec new(list) :: list(MyspaceIPFS.Dht.query_response_addrs())
  def new(response) when is_list(response) do
    response
    |> Enum.map(&new/1)
  end

  @spec new(nil) :: list
  def new(response) when is_nil(response), do: []
end
