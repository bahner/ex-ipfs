defmodule MyspaceIPFS.Api.Diag do
    @moduledoc """
  MyspaceIPFS.Api is where the diag commands of the IPFS API reside.
  """

    # DIAG COMMANDS
    # NB: diag_profile is not implemented yet.
    # NB: diag_net is deactivated.

    def diag_cmds, do: request_get("/diag/cmds")

    def diag_cmds_clear, do: request_get("/diag/cmds/clear")

    def diag_cmds_set_time(time), do: request_get("/diag/cmds/set-time?arg=", time)

    def diag_sys, do: request_get("/diag/sys")
end
