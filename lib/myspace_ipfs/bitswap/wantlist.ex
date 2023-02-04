defmodule MyspaceIPFS.BitswapWantList do
  @moduledoc """
  A struct that represents the wantlist for a peer in the bitswap network.
  """

  # API actually returns null, not an empty list.
  defstruct keys: nil

  @type t :: %__MODULE__{
          keys: list | nil
        }

  @doc false
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
