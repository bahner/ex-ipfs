defmodule MyspaceIPFS.Path do
  @moduledoc """
  A struct that a resolved IPFS/IPNS path.
  """
  defstruct path: nil

  @type t :: %__MODULE__{
          path: Path.t() | nil
        }

  @spec new(map) :: MyspaceIPFS.Path.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      path: opts["Path"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
