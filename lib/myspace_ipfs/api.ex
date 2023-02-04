defmodule MyspaceIPFS.Api do
  @moduledoc false
  use Tesla, docs: false
  alias MyspaceIPFS.ApiError
  require Logger
  import MyspaceIPFS.Utils, only: [unokify: 1, filter_empties: 1]

  @api_url Application.compile_env(:myspace_ipfs, :api_url, "http://localhost:5001/api/v0/")

  # Types
  @typep path :: MyspaceIPFS.path()
  @typep opts :: MyspaceIPFS.opts()
  @typep multipart :: Tesla.Multipart.t()

  @typep api_response :: binary | map | list | api_error
  @typep api_error ::
           {:error, MyspaceIPFS.ApiError.t()} | {:error, Tesla.Env.t()} | {:error, atom}

  # Middleware
  plug(Tesla.Middleware.BaseUrl, @api_url)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger)

  @doc """
  High level function allowing to perform POST requests to the node.
  A `path` has to be provided, along with an optional list of `opts` that are
  dependent on the endpoint that will get hit.
  NB! This is not a GET request, but a POST request. IPFS uses POST requests.
  """
  @spec post_query(path, opts) :: api_response
  def post_query(path, opts \\ []) do
    post(path, <<>>, opts)
    |> handle_response()
  end

  @doc """
  High level function allowing to send data to the node.
  A `path` has to be specified along with the `data` to be sent. Also, a list
  of `opts` can be optionally sent.

  Data is sent first, so that it can easily be part of a pipe.
  """
  @spec post_multipart(multipart, binary, list) :: api_response
  def post_multipart(mp, path, opts \\ []) do
    post(path, mp, opts)
    |> handle_response()
  end

  @spec handle_response({:ok, Tesla.Env.t()}) :: api_response
  def handle_response(response) do
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

      {:ok, %Tesla.Env{status: 400}} ->
        {:error, unokify(response)}

      {:ok, %Tesla.Env{status: 403}} ->
        {:error, unokify(response)}

      {:ok, %Tesla.Env{status: 404}} ->
        {:error, unokify(response)}

      {:ok, %Tesla.Env{status: 405}} ->
        {:error, unokify(response)}

      {:error, {Tesla.Middleware.JSON, :decode, json_error}} ->
        extract_data_from_json_error(json_error.data)

      {:error, :timeout} ->
        {:error, :timeout}
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
      _ -> error
    end
  end
end
