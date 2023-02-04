defmodule MyspaceIPFS.BlockKeySize do
  @moduledoc """
  MyspaceIPFS.BlockKeySize is a struct returned from the IPFS Block API.
  """

  defstruct key: nil, size: nil

  @type t :: %__MODULE__{key: binary, size: non_neg_integer}

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts["Key"],
      size: opts["Size"]
    }
  end
end
