defmodule MyspaceIPFS.SlashCID do
  @moduledoc false
  defstruct /: nil

  require Logger

  @spec new(any) :: MyspaceIPFS.slash_cid()
  def new(cid) when is_map(cid) do
    case cid do
      %{"/" => something} ->
        %__MODULE__{/: something}

      _ ->
        %__MODULE__{/: cid./}
    end
  end
end
