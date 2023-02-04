defmodule MyspaceIPFS.HashLinks do
  @moduledoc """
  This struct is very simple. Some results are listed as "Hash": hash, "Links": links. This is a
  convenience struct to make it easier match on the result.
  """

  defstruct hash: nil, links: []

  @type t :: %__MODULE__{hash: binary, links: list}

  @spec new(map) :: MyspaceIPFS.HashLinks.t()
  def new(opts) when is_map(opts) do
    with links <- opts["Links"] |> Enum.map(&MyspaceIPFS.Hash.new/1),
         do: %__MODULE__{
           hash: opts["Hash"],
           links: links
         }
  end

  # Pass on errors.
  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
