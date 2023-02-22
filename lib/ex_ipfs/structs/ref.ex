defmodule ExIpfs.Ref do
  @moduledoc false

  @enforce_keys [:ref]
  defstruct [
    :ref,
    :err
  ]

  @spec new(map) :: ExIpfs.ref()
  def new(map) when is_map(map) do
    %__MODULE__{
      ref: map["Ref"],
      err: map["Err"]
    }
  end

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}), do: {:error, data}
end
