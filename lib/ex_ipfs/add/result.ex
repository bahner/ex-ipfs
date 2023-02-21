defmodule ExIPFS.AddResult do
  @moduledoc false

  defstruct bytes: 0, hash: nil, size: nil, name: nil

  @spec new(map) :: ExIPFS.add_result()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      bytes: Map.get(opts, "Bytes", 0),
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"]
    }
  end

  @spec new(list) :: list(ExIPFS.add_result())
  def new(opts) when is_list(opts) do
    Enum.map(opts, &new/1)
  end

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
