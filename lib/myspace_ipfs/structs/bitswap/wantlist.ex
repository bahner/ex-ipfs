defmodule MyspaceIpfs.BitswapWantList do
  @moduledoc """
  A struct that represents the wantlist for a peer in the bitswap network.
  """

  import MyspaceIpfs.Utils
  defstruct keys: []

  @typep rootcid :: MyspaceIpfs.RootCid.t()

  @type t :: %__MODULE__{
          keys: list[rootcid] | nil
        }

  @doc """
  Generate a new BitswapWantList struct or passthrough an error message
  from the IPFS API
  """
  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: MyspaceIpfs.BitswapWantList.t()
  def new(opts) do
    opts = snake_atomize(opts)
    %__MODULE__{
      keys: opts.keys
    }
  end
end
