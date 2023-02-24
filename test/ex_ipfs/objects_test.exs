defmodule ExIpfs.Objects do
  @moduledoc false

  defstruct objects: []

  @spec new(map) :: ExIpfs.objects()
  def new(opts) when is_map(opts) do
    objects =
      opts["Objects"]
      |> Enum.map(&ExIpfs.ObjectLinks.new/1)

    %__MODULE__{
      objects: objects
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
