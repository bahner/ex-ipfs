defmodule MyspaceIPFS.Objects do
  @moduledoc """
  This struct is very simple. Some results are listed as "Hash": hash, "Links": links. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct objects: []

  @type t :: %__MODULE__{objects: list}

  @spec new(map) :: MyspaceIPFS.Objects.t()
  def new(opts) when is_map(opts) do
    objects =
      opts["Objects"]
      |> Enum.map(&MyspaceIPFS.HashLinks.new/1)

    %__MODULE__{
      objects: objects
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
