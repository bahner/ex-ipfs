defmodule ExIPFS.Link do
  @moduledoc false

  @enforce_keys [:/]
  defstruct /: nil

  require Logger

  @spec new(map | binary) :: ExIPFS.link()
  def new(cid) when is_map(cid) do

        %__MODULE__{/: cid["/"]}
  end

  def new(cid) when is_binary(cid) do
    %__MODULE__{/: cid}
  end

  # Pass on errors.

  @spec new({:error, any}) :: {:error, any}
  def new({:error, data}), do: {:error, data}
end
