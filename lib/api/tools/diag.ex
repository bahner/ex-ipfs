defmodule MyspaceIPFS.Api.Tools.Diag do
  @moduledoc """
  MyspaceIPFS.Api is where the diag commands of the IPFS API reside.
  """
  import MyspaceIPFS

  # DIAG COMMANDS
  # NB: profile is not implemented yet.
  # NB: net is deactivated.

  def cmds, do: post_query("/diag/cmds")

  def cmds_clear, do: post_query("/diag/cmds/clear")

  def cmds_set_time(time), do: post_query("/diag/cmds/set-time?arg=" <> time)

  def sys, do: post_query("/diag/sys")
end
