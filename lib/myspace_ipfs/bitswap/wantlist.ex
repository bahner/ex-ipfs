defmodule MyspaceIpfs.BitswapWantList do
  @moduledoc """
  A struct that represents the wantlist for a peer in the bitswap network.
  """
  defstruct keys: nil

  @typep rootcid :: MyspaceIpfs.RootCid.t()

  @type t :: %__MODULE__{
          keys: list[rootcid]
        }
end
