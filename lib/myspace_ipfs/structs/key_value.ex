defmodule MyspaceIPFS.Structs.KeyValue do
  @moduledoc false

  defstruct key: nil, value: nil

  @spec new(map) :: MyspaceIPFS.key_value()
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
