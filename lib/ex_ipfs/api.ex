defmodule ExIpfs.Api do
  @moduledoc """
  A module that contains the functions that are used to interact with the IPFS API.
  """
  use Tesla, docs: false
  alias ExIpfs.ApiError
  require Logger
  import ExIpfs.Utils, only: [unokify: 1, filter_empties: 1]

  @api_url Application.compile_env(:ex_ipfs, :api_url, "http://localhost:5001/api/v0/")

  # Types

  @typedoc """
  A structured error returned from the upstream IPFS API.

  """
  @type error :: %ExIpfs.ApiError{
          code: integer,
          message: binary,
          type: binary
        }

  @typedoc """
  A type that represents the possible responses from the API.
  """
  @type response :: binary | map | list | error_response

  @typedoc """
  A an aggregate type that represents the possible errors that can be returned from the API.
  """
  @type error_response ::
          {:error, ExIpfs.Api.error()} | {:error, Tesla.Env.t()} | {:error, atom}

  # Middleware
  plug(Tesla.Middleware.BaseUrl, @api_url)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger)

  @doc false
  @spec post_query(Path.t(), list()) :: response
  def post_query(path, opts \\ []) do
    post(path, <<>>, opts)
    |> handle_response()
  end

  @doc false
  @spec post_multipart(Tesla.Multipart.t(), binary, list()) :: response
  def post_multipart(mp, path, opts \\ []) do
    post(path, mp, opts)
    |> handle_response()
  end

  @doc false
  defp handle_response(response) do
    # Handles the response from the node. It returns the body of the response
    # if the status code is 200, otherwise it returns an error tuple.
    # ## Status codes that are handled
    # https://docs.ipfs.tech/reference/kubo/rpc/#http-status-codes
    #   - 200 - The request was processed or is being processed (streaming)
    #   - 500 - RPC Endpoint returned an error
    #   - 400 - Malformed RPC, argument type error, etc.
    #   - 403 - RPC call forbidden
    #   - 404 - RPC endpoint does not exist
    #   - 405 - RPC endpoint exists but method is not allowed
    # Removing categorised status codes from the case statement.
    # This is of no use to the user, and not for the code either, as far as I can think of.
    # It just gives us more to match against, which is needlessly complex.

    case response do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        body

      {:ok, %Tesla.Env{status: 500, body: body}} ->
        ApiError.handle_api_error(body)

      # coveralls-ignore-start
      {:ok, %Tesla.Env{status: 400}} ->
        {:error, unokify(response)}

      {:ok, %Tesla.Env{status: 403}} ->
        {:error, unokify(response)}

      {:ok, %Tesla.Env{status: 404}} ->
        {:error, unokify(response)}

      {:ok, %Tesla.Env{status: 405}} ->
        {:error, unokify(response)}

      # coveralls-ignore-stop

      {:error, {Tesla.Middleware.JSON, :decode, json_error}} ->
        extract_data_from_json_error(json_error.data)

      # coveralls-ignore-start
      {:error, :timeout} ->
        {:error, :timeout}
        # coveralls-ignore-stop
    end
  end

  defp extract_data_from_json_error(error) do
    Logger.debug("Extract DATA from JSON Error: #{inspect(error)}")

    try do
      error
      |> String.split("\n")
      |> filter_empties()
      # Please note that Jason.decode *must* have input as a string.
      # Hence the interpolation.
      |> Enum.map(fn line -> Jason.decode!("#{line}") end)
    rescue
      # coveralls-ignore-start
      _ ->
        error
        # coveralls-ignore-stop
    end
  end
end
