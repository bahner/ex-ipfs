defmodule MyspaceIPFS.Add do
  @moduledoc false

  defstruct bytes: nil, hash: nil, size: nil, name: nil

  @type t :: %__MODULE__{
          bytes: non_neg_integer,
          hash: binary,
          name: binary,
          size: non_neg_integer
        }

  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      bytes: opts["Bytes"],
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"]
    }
  end

  @spec new(list) :: list(t())
  def new(opts) when is_list(opts) do
    Enum.map(opts, &new/1)
  end

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
