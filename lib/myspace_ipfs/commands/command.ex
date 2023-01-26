defmodule MyspaceIpfs.CommandsCommand do
  @moduledoc """
  MyspaceIpfs.Commands is where the commands commands of the IPFS API reside.
  """

  defstruct name: nil, options: [], subcommands: []

  @type t :: %__MODULE__{
          name: binary,
          options: list,
          subcommands: list[t]
        }

  require Logger

  @doc """
  Generate command struct for a command object
  """
  @spec gen_command(map) :: t
  def gen_command(opts) do
    %__MODULE__{} |> struct(opts)
  end

  @doc """
  Generate command struct subcommands of a command object
  """
  @spec gen_commands(map) :: list[t]
  def gen_commands(command) when is_map(command) do
    if has_subcommands?(command) do
      Logger.debug("Generating subcommands for #{command.name}")
      %{command | subcommands: Enum.map(command.subcommands, &gen_commands/1)}
    else
      Logger.debug("Generating command #{command.name}")
      gen_command(command)
    end
  end

  defp has_subcommands?(command) when is_map(command) do
    Map.has_key?(command, :subcommands) && command.subcommands != []
  end

  defp has_subcommands?(command) when is_list(command) do
    command != []
  end
end
