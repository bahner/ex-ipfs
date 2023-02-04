defmodule MyspaceIPFS.KeyValue do
  @moduledoc """
  This struct is very simple. Some results are listed as "Value": size. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct key: nil, value: nil

  @type t :: %__MODULE__{key: binary, value: binary}

  @spec new(map) :: MyspaceIPFS.KeyValue.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts.key,
      value: opts.value
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
