defmodule MyspaceIPFS.Utils do
  @moduledoc """
  MyspaceIPFS.Utils is where common functions of the library are defined.

  Alias this library and you can run the commands via Utils.<cmd_name>.

      ## Examples

      iex> alias MyspaceIPFS.Utils, as: Utils
      iex> Api.get("Multihash_key")
      <<0, 19, 148, 0, ... >>
  """

  import MyspaceIPFS.Connection

  # IPCS API HTTP Status Codes
  # Ref. https://docs.ipfs.tech/reference/kubo/rpc/#http-status-codes
  #       for any other status codes.
  # 200 - The request was processed or is being processed (streaming)
  # 500 - RPC endpoint returned an error
  # 400 - Malformed RPC, argument type error, etc
  # 403 - RPC call forbidden
  # 404 - RPC endpoint doesn't exist
  # 405 - HTTP Method Not Allowed

  defp handle_response(response) do
    case response do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
      {:ok, %Tesla.Env{status: 500, body: body}} -> {:server_error, body}
      {:ok, %Tesla.Env{status: 400, body: body}} -> {:client_error, body}
      {:ok, %Tesla.Env{status: 403, body: body}} -> {:forbidden, body}
      {:ok, %Tesla.Env{status: 404, body: body}} -> {:missing, body}
      {:ok, %Tesla.Env{status: 405, body: body}} -> {:not_allowed, body}
    end
  end

  # Not sure how and when to use this.
  # defp write_file(raw, multihash) do
  #     File.write(multihash, raw, [:write, :utf8])
  # end

  @spec request_post(any, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def request_post(file, path) do
    handle_response(post(path, file))
  end

  @spec request_get(binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def request_get(path) do
    handle_response(post(path, ""))
  end

  @spec request_get(binary, binary) ::
          {:client_error | :forbidden | :missing | :not_allowed | :ok | :server_error, any}
  def request_get(path, arg) do
    handle_response(post(path <> arg, ""))
  end
end
