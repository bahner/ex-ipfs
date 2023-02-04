defmodule MyspaceIPFS.AddResult do
  @moduledoc """
  A struct that represents the result of an add operation.
  """

  defstruct bytes: nil, hash: nil, size: nil, name: nil

  @type t :: %__MODULE__{
          bytes: non_neg_integer,
          hash: binary,
          name: binary,
          size: non_neg_integer
        }

  @doc false
  @spec new(map) :: t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      bytes: opts["Bytes"],
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"]
    }
  end

  @doc false
  @spec new(list) :: list(t())
  def new(opts) when is_list(opts) do
    Enum.map(opts, &new/1)
  end

  @doc false
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
