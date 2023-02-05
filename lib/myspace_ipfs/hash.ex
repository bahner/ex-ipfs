defmodule MyspaceIPFS.Hash do
  @moduledoc false
  @enforce_keys [:hash, :name, :size, :type]
  defstruct hash: nil, name: nil, size: nil, target: "", type: nil

  @spec new(map) :: MyspaceIPFS.hash()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"],
      target: opts["Target"],
      type: opts["Type"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
