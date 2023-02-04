defmodule MyspaceIPFS.KeySize do
  @moduledoc """
  This struct is very simple. Some results are listed as "Size": size. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct key: nil, size: nil

  @type t :: %__MODULE__{key: binary, size: non_neg_integer}

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}

  @spec new(map) :: MyspaceIPFS.KeySize.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts.key,
      size: opts.size
    }
  end
end
