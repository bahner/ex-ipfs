defmodule MyspaceIPFS.AddResult do
  @moduledoc false

  defstruct bytes: nil, hash: nil, size: nil, name: nil

  @spec new(map) :: MyspaceIPFS.add_result()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      bytes: opts["Bytes"],
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"]
    }
  end

  @spec new(list) :: list(MyspaceIPFS.add_result())
  def new(opts) when is_list(opts) do
    Enum.map(opts, &new/1)
  end

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
