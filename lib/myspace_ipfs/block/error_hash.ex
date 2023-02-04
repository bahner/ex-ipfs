defmodule MyspaceIPFS.BlockErrorHash do
  @moduledoc false

  defstruct error: "", hash: nil

  @type t :: %__MODULE__{error: binary, hash: binary}

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      error: Map.get(opts, "Error", ""),
      hash: opts["Hash"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
