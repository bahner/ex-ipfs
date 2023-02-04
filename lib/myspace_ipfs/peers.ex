defmodule MyspaceIPFS.Peers do
  @moduledoc """
  A struct that represents the wantlist for a peer in the bitswap network.
  """
  defstruct peers: []

  @type t :: %__MODULE__{
          peers: list | nil
        }
  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      peers: opts["Peers"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
