defmodule MyspaceIPFS.BlockErrorHash do
  @moduledoc """
  MyspaceIPFS.BlockErrorHash is a struct returned from the IPFS Block API.
  """

  defstruct error: "", hash: nil

  @typedoc """
  A structure from the API that is an error and its hash.
  ```
  %MyspaceIPFS.BlockErrorHash{
    error: binary,
    hash: binary
  }
  ```
  """
  @type t :: %__MODULE__{error: binary, hash: binary}

  @doc false
  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      error: Map.get(opts, "Error", ""),
      hash: opts["Hash"]
    }
  end

  # Pass on errors.
  @doc false
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
