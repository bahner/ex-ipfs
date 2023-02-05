defmodule MyspaceIPFS.FilesEntry do
  @moduledoc false
  @enforce_keys [:hash, :name, :size, :type]
  defstruct hash: nil, name: nil, size: nil, type: nil

  @spec new(map) :: MyspaceIPFS.Files.entry()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"],
      type: opts["Type"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
