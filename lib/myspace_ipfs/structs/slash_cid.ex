defmodule MyspaceIPFS.Structs.SlashCID do
  @moduledoc false
  defstruct /: nil

  @spec new(any) :: MyspaceIPFS.slash_cid()
  def new(cid) do
    case cid do
      %{"/" => something} ->
        %__MODULE__{/: something}

      _ ->
        %__MODULE__{/: cid}
    end
  end
end
