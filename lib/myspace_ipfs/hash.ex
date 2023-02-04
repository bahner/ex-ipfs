defmodule MyspaceIPFS.Hash do
  @moduledoc """
  This struct is very simple. Some results are listed as "Hash": hash. This is a
  convenience struct to make it easier match on the result.
  """
  @enforce_keys [:hash, :name, :size, :type]
  defstruct hash: nil, name: nil, size: nil, target: "", type: nil

  @type t :: %__MODULE__{
          hash: binary,
          name: binary,
          size: non_neg_integer,
          target: binary,
          type: non_neg_integer()
        }

  @spec new(map) :: MyspaceIPFS.Hash.t()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      hash: opts["Hash"],
      name: opts["Name"],
      size: opts["Size"],
      target: opts["Target"],
      type: opts["Type"]
    }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
