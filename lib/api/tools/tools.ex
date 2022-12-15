defmodule MyspaceIPFS.Api.Tools do
  @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  """

  import MyspaceIPFS.Utils
  # Update function  - takes in the current args for update.
  @spec update(binary) :: any
  def update(args) when is_bitstring(args) do
    {:ok, res} = request_get("/update?arg=", args)
    res.body |> String.replace(~r/\r|\n/, "")
  end

  # version function - does not currently accept the optional arguments on golang client.
  @spec version(any, any, any, any) :: any
  def version(num \\ false, comm \\ false, repo \\ false, all \\ false) do
    request_get(
      "/version?number=" <>
        to_string(num) <>
        "&commit=" <> to_string(comm) <> "&repo=" <> to_string(repo) <> "&all=" <> to_string(all),
      ""
    )
  end
end
