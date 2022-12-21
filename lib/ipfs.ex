defmodule MyspaceIPFS do
  @moduledoc """
  IPFS (the InterPlanetary File Syste
  new hypermedia distribution protocol, addressed by
  content and identities. IPFS enables the creation of
  completely distributed applications. It aims to make the web
  faster, safer, and more open.


  IPFS is a distributed file system that seeks to connect
  all computing devices with the same system of files. In some
  ways, this is similar to the original aims of the Web, but IPFS
  is actually more similar to a single bittorrent swarm exchanging
  git objects.

  Forked from https://github.com/tensor-programming/Elixir-Ipfs-Api

  Based on https://github.com/tableturn/ipfs/blob/master/lib/ipfs.ex
  """
  use Tesla, docs: false
  alias Tesla.Multipart

  # Config
  @baseurl Application.get_env(:myspace_ipfs, :baseurl)
  @debug Application.get_env(:myspace_ipfs, :debug)

  # Types
  @typedoc """
  The path to the endpoint to be hit. For example, `/add` or `/cat`.
  It's called path because sometimes the MultiHash is not enough to
  identify the resource, and a path is needed, eg. /ipns/myspace.bahner.com
  """
  @type path :: String.t()
  @typedoc """
  The file system path to the file to be sent to the node.
  """
  @type fspath :: String.t()
  @typedoc """
  The name of the file or data to be sent to the node.
  """
  @type name :: String.t()
  @typedoc """
  The options to be sent to the node. These are dependent on the endpoint
  """
  @type opts :: list

  @typedoc """
  The structure of a normal error response from the node.
  """
  @type error :: {:error, Tesla.Env.t()}
  @typedoc """
  The structure of a normal response from the node.
  """
  @type mapped :: {:ok, list} | {:error, Tesla.Env.t()}
  @typedoc """
  The structure of a JSON response from the node.
  """
  @type result :: {:ok, any} | {:error, Tesla.Env.t()}

  # Middleware
  plug(Tesla.Middleware.BaseUrl, @baseurl)
  @debug && plug(Tesla.Middleware.Logger)

  @doc """
  High level function allowing to perform POST requests to the node.
  A `path` has to be provided, along with an optional list of `opts` that are
  dependent on the endpoint that will get hit.
  NB! This is not a GET request, but a POST request. IPFS uses POST requests.
  """
  @spec post_query(path, opts) :: result
  def post_query(path, opts \\ []) do
    handle_response(post(@baseurl <> path, "", opts))
  end

  @doc """
  High level function allowing to send file contents to the node.
  A `path` has to be specified along with the `fspath` to be sent. Also, a list
  of `opts` can be optionally sent.
  """
  @spec post_file(path, fspath, opts) :: result
  def post_file(path, fspath, opts \\ []) do
    cond do
      File.dir?(fspath) ->
        {:error, "FIXME: Upload off directories not implented yet."}

      not File.exists?(fspath) ->
        {:error, "fspath does not exist"}

      true ->
        handle_response(post(path, multipart(fspath), opts))
    end
  end

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
  defp handle_response(response) do
    case response do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 500}} -> {:error, response}
      {:ok, %Tesla.Env{status: 400}} -> {:error, response}
      {:ok, %Tesla.Env{status: 403}} -> {:error, response}
      {:ok, %Tesla.Env{status: 404}} -> {:error, response}
      {:ok, %Tesla.Env{status: 405}} -> {:error, response}
      {:error, _} -> {:error, response}
    end
  end

  defp multipart(fspath) do
    Multipart.new()
    |> Multipart.add_file(fspath,
      name: "file",
      filename: "#{fspath}",
      detect_content_type: true
    )
  end

  @doc """
  High level function which creates a list of maps from the response data.
  """
  @spec map_response_data(binary) :: mapped
  defdelegate map_response_data(response), to: MyspaceIPFS.Utils

  @spec okify(any) :: {:ok, any} | {:error, any}
  def okify({:error, _} = err), do: err
  def okify(res), do: {:ok, res}
end
