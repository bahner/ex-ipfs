defmodule ExIPFS.FilesStat do
  @moduledoc false
  defstruct blocks: nil, cumulative_size: nil, hash: nil, size: nil, type: nil

  @spec new(map) :: ExIPFS.Files.stat()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      blocks: opts["Blocks"],
      cumulative_size: opts["CumulativeSize"],
      hash: opts["Hash"],
      size: opts["Size"],
      type: opts["Type"]
    }
  end

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
