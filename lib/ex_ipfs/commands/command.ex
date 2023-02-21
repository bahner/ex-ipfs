defmodule ExIPFS.CommandsCommand do
  @moduledoc false
  defstruct name: nil, options: [], subcommands: []

  require Logger

  @spec new({:error, map}) :: {:error, map}
  def new({:error, data}) do
    {:error, data}
  end

  @spec new(map) :: ExIPFS.Commands.command()
  def new(opts) do
    %__MODULE__{
      name: opts["Name"],
      options: opts["Options"],
      subcommands: Enum.map(opts["Subcommands"], &gen_commands/1)
    }
  end

  defp gen_commands(command) when is_map(command) do
    if has_subcommands?(command) do
      Logger.debug("Generating subcommands for #{command["Name"]}")
      %{command | subcommands: Enum.map(command["Subcommands"], &gen_commands/1)}
    else
      Logger.debug("Generating command #{command["Name"]}")
      new(command)
    end
  end

  defp has_subcommands?(command) when is_map(command) do
    Map.has_key?(command, :subcommands) && command.subcommands != []
  end
end
