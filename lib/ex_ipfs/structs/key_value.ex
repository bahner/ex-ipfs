defmodule ExIpfs.KeyValue do
  @moduledoc false

  defstruct key: nil, value: nil

  @spec new(map) :: ExIpfs.key_value()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      key: opts["Key"],
      value: opts["Value"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
