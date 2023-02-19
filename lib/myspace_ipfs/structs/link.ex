defmodule MyspaceIPFS.Link do
  @moduledoc false
  defstruct /: nil

  require Logger

  @spec new(any) :: MyspaceIPFS.link()
  def new(cid) when is_map(cid) do
    case cid do
      %{"/" => something} ->
        %{/: something}

      _ ->
        %{/: cid./}
    end
  end
end
