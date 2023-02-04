defmodule MyspaceIPFS.ErrorHash do
  @moduledoc """
  This struct is very simple. Some results are listed as "Error": error, "Hash": hash. This is a
  """

  defstruct error: "", hash: nil

  @type t :: %__MODULE__{error: binary, hash: binary}

  @spec new(map) :: MyspaceIPFS.ErrorHash.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      error: Map.get(opts, :error, ""),
      hash: opts.hash
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
