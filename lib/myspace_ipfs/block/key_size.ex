defmodule MyspaceIPFS.BlockKeySize do
  @moduledoc """
  MyspaceIPFS.BlockKeySize is a struct returned from the IPFS Block API.
  """

  defstruct key: nil, size: nil

  @typedoc """
  A structure from the API that is a key and its size.
  ```
  %MyspaceIPFS.BlockKeySize{
    key: binary,
    size: non_neg_integer
  }
  ```
  """

  @type t :: %__MODULE__{key: binary, size: non_neg_integer}

  @doc false
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}

  @doc false
  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts["Key"],
      size: opts["Size"]
    }
  end
end
