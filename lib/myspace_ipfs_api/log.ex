defmodule MyspaceIPFS.Api.Log do
    @moduledoc """
  MyspaceIPFS.Api.Log is where the log commands of the IPFS API reside.
  """
    def log_level(subsys, level), do: request_get("/log/level?arg=" <> subsys <> "&arg=" <> level)

    def log_ls, do: request_get("/log/ls")

    def log_tail, do: request_get("/log/tail")
end
