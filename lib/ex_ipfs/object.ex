defmodule ExIpfs.Object do
  @moduledoc false

  @enforce_keys [:hash]
  defstruct hash: nil, links: []

  @spec new(map) :: ExIpfs.object()
  def new(object) when is_map(object) do
    with links <- object["Links"] |> Enum.map(&ExIpfs.Object.new/1),
         do: %__MODULE__{
           hash: object["Hash"],
           links: links
         }
  end

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
