defmodule MyspaceIPFS.BlockErrorHash do
  @moduledoc false
  defstruct error: "", hash: nil

  @spec new(map) :: MyspaceIPFS.Block.error_hash()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      error: Map.get(opts, "Error", ""),
      hash: opts["Hash"]
    }
  end

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
