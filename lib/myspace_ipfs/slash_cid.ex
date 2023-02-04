defmodule MyspaceIPFS.SlashCID do
  @moduledoc """
  This struct is very simple. Some results are listed as `%{"/": cid}`. This is a
  convenience struct to make it easier match on the result.

  The name is odd, but it signifies that it is a CID of in the API notation, with the
  leading slash.
  """

  @typep cid :: MyspaceIPFS.cid()
  # The CID of the root object.
  defstruct /: nil

  @type t :: %__MODULE__{/: cid}

  @spec new(any) :: t()
  def new(cid) do
    case cid do
      %{"/" => something} ->
        %__MODULE__{/: something}

      _ ->
        %__MODULE__{/: cid}
    end
  end
end
