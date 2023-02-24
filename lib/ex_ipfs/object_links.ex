defmodule ExIpfs.ObjectLinks do
  @moduledoc false

  defstruct hash: nil, links: []

  @spec new(map) :: ExIpfs.object_links()
  def new(opts) when is_map(opts) do
    with links <- opts["Links"] |> Enum.map(&ExIpfs.Object.new/1),
         do: %__MODULE__{
           hash: opts["Hash"],
           links: links
         }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
