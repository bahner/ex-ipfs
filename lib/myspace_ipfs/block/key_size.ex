defmodule MyspaceIPFS.BlockKeySize do
  @moduledoc false
  defstruct key: nil, size: nil

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: MyspaceIPFS.Block.key_size()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts["Key"],
      size: opts["Size"]
    }
  end
end
