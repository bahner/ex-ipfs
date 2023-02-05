defmodule MyspaceIPFS.BitswapWantList do
  @moduledoc false

  # API actually returns null, not an empty list.
  defstruct keys: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIPFS.Bitswap.wantlist()
  def new(opts) do
    %__MODULE__{
      keys: opts["Keys"]
    }
  end
end
