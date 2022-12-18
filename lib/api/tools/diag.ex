defmodule MyspaceIPFS.Api.Tools.Diag do
  @moduledoc """
  MyspaceIPFS.Api is where the diag commands of the IPFS API reside.
  """
  import MyspaceIPFS

  # DIAG COMMANDS
  # NB: profile is not implemented yet.
  # NB: net is deactivated.

  @spec cmds :: {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def cmds, do: post_query("/diag/cmds")

  @spec cmds_clear ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def cmds_clear, do: post_query("/diag/cmds/clear")

  @spec cmds_set_time(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def cmds_set_time(time), do: post_query("/diag/cmds/set-time?arg=", time)

  @spec sys ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def sys, do: post_query("/diag/sys")
end
