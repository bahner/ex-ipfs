defmodule MyspaceIPFS.Api.Tools do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """
  import MyspaceIPFS

  # Update function  - takes in the current args for update.
  # This runs ipfs update with the given arguments.
  # You probably don't want to use this unless you know what you're doing.
  def update(args) when is_bitstring(args) do
    {:ok, res} = post_query("/update?arg=", args)
    res.body |> String.replace(~r/\r|\n/, "")
  end

  # version function - does not currently accept the optional arguments on golang client.
  def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
    post_query(
      "/version?number=" <>
        to_string(num) <>
        "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all),
      ""
    )
  end
end
