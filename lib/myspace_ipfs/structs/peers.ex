defmodule MyspaceIPFS.Structs.Peers do
  @moduledoc false
  defstruct peers: []

  @spec new(map) :: MyspaceIPFS.peers()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      peers: opts["Peers"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
