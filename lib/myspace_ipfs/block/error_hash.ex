defmodule MyspaceIPFS.BlockErrorHash do
  @moduledoc """
  MyspaceIPFS.BlockErrorHash is a struct returned from the IPFS Block API.
  """

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
