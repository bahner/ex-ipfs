defmodule ExIpfs.Strings do
  @moduledoc false
  @enforce_keys [:strings]
  defstruct strings: []

  @spec new(tuple) :: ExIpfs.strings() | ExIpfs.Api.error_response()
  def new(data) when is_tuple(data) do
    case data do
      {_, nil} ->
        new(%{"Strings" => []})

      {:error, error} ->
        {:error, error}

      _ ->
        new(%{"Strings" => []})
    end
  end

  @spec new(map) :: ExIpfs.strings()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      strings: Map.get(opts, "Strings", [])
    }
  end

  @spec new(list) :: list(ExIpfs.strings())
  def new(opts) when is_list(opts) do
    Enum.map(opts, &new/1)
  end
end
