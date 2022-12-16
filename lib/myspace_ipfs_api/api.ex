defmodule MyspaceIPFS.Api do
    @moduledoc """
  MyspaceIPFS.Api is where the main commands of the IPFS API reside.
  Alias this library and you can run the commands via API.<cmd_name>.

        ## Examples

        iex> alias MyspaceIPFS.Api, as: Api
        iex> Api.get("Multihash_key")
        <<0, 19, 148, 0, ... >>
  """

    import MyspaceIPFS.Connection

    # TODO: add ability to add options to the ipfs daemon command.
    # TODO: read ipfs config from config file.
    def start_shell(start? \\ true, flag \\ []) do
        {:ok, pid} = Task.start(fn -> System.cmd("ipfs", ["daemon"]) end)
        if start? == false do
            pid |> shutdown(flag)
        else
            pid
        end
    end

    use MyspaceIPFS.Api.Main

    alias MyspaceIPFS.Api.Bitswap
    alias MyspaceIPFS.Api.Block
    alias MyspaceIPFS.Api.Bootstrap
    alias MyspaceIPFS.Api.Cid
    alias MyspaceIPFS.Api.Commands
    alias MyspaceIPFS.Api.Dag
    alias MyspaceIPFS.Api.Files
    alias MyspaceIPFS.Api.Filestore
    alias MyspaceIPFS.Api.Key
    alias MyspaceIPFS.Api.Log
    alias MyspaceIPFS.Api.Multilevel
    alias MyspaceIPFS.Api.Name
    alias MyspaceIPFS.Api.Pin
    alias MyspaceIPFS.Api.Refs
    alias MyspaceIPFS.Api.Repo
    alias MyspaceIPFS.Api.Routing
    alias MyspaceIPFS.Api.Stats
    alias MyspaceIPFS.Api.Swarm
    alias MyspaceIPFS.Api.PubSub

    # IPCS API HTTP Status Codes
    # Ref. https://docs.ipfs.tech/reference/kubo/rpc/#http-status-codes
    #       for any other status codes.
    # 200 - The request was processed or is being processed (streaming)
    # 500 - RPC endpoint returned an error
    # 400 - Malformed RPC, argument type error, etc
    # 404 - RPC endpoint doesn't exist
    # 405 - HTTP Method Not Allowed

    defp handle_response(response) do
        case response do
            {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
            {:ok, %Tesla.Env{status: 500, body: body}} -> {:server_error, body}
            {:ok, %Tesla.Env{status: 400, body: body}} -> {:client_error, body}
            {:ok, %Tesla.Env{status: 404, body: body}} -> {:missing, body}
            {:ok, %Tesla.Env{status: 405, body: body}} -> {:not_allowed, body}
        end
    end

    defp request_post(file, path) do
        handle_response(post(path, file))
    end

    defp request_get(path) do
        handle_response(post(path, ""))
    end

    defp request_get(path, arg) do
        handle_response(post(path <> arg, ""))
    end


    # defp write_file(raw, multihash) do
    #   File.write(multihash, raw, [:write, :utf8])
    # end
end
