defmodule MyspaceIPFS.BitswapWantList do
  @moduledoc """
  MyspaceIPFS.BitswapWantList is a struct returned from the IPFS Bitswap API.
  """

  # API actually returns null, not an empty list.
  defstruct keys: nil

  @type t :: %__MODULE__{
          keys: list | nil
        }

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: t()
  def new(opts) do
    %__MODULE__{
      keys: opts["Keys"]
    }
  end
end
