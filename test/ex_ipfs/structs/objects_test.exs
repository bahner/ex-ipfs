defmodule ExIPFS.Objects do
  @moduledoc false

  defstruct objects: []

  @spec new(map) :: ExIPFS.objects()
  def new(opts) when is_map(opts) do
    objects =
      opts["Objects"]
      |> Enum.map(&ExIPFS.HashLinks.new/1)

    %__MODULE__{
      objects: objects
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
