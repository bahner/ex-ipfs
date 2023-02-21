defmodule ExIPFS.DiagCmd do
  @moduledoc false

  require Logger

  defstruct active: nil,
            args: nil,
            command: nil,
            end_time: nil,
            id: nil,
            options: nil,
            start_time: nil

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: ExIPFS.Diag.cmd()
  def new(opts) when is_map(opts) do
    %__MODULE__{
      active: opts["Active"],
      args: opts["Args"],
      command: opts["Command"],
      end_time: opts["EndTime"],
      id: opts["ID"],
      options: opts["Options"],
      start_time: opts["StartTime"]
    }
  end

  @spec new(list) :: list(ExIPFS.Diag.cmd())
  def new(response) when is_list(response) do
    Enum.map(response, &new/1)
  end
end
