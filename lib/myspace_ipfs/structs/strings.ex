defmodule MyspaceIPFS.Strings do
  @moduledoc false
  @enforce_keys [:strings]
  defstruct strings: []

  @spec new(map) :: MyspaceIPFS.strings()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      strings: opts["Strings"]
    }
  end

  @spec new(list) :: list(MyspaceIPFS.strings())
  def new(opts) when is_list(opts) do
    Enum.map(opts, &new/1)
  end

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
