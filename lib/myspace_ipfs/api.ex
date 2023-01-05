defmodule MyspaceIPFS.Api do
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
  @baseurl Application.compile_env(:myspace_ipfs, :baseurl)
  @debug Application.compile_env(:myspace_ipfs, :debug)

  # Types
  @typep path :: MyspaceIPFS.path()
  @typep fspath :: MyspaceIPFS.fspath()
  @typep opts :: MyspaceIPFS.opts()
  @typep result :: MyspaceIPFS.result()

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
    handle_response(post(path, "", opts))
  end

  @doc """
  High level function allowing to send data to the node.
  A `path` has to be specified along with the `data` to be sent. Also, a list
  of `opts` can be optionally sent.
  """
  @spec post_data(path, any, opts) :: result
  def post_data(path, data, opts \\ []) do
    handle_response(post(path, data, opts))
  end

  @doc """
  High level function allowing to send file contents to the node.
  A `path` has to be specified along with the `fspath` to be sent. Also, a list
  of `opts` can be optionally sent.
  """
  @spec post_file(path, fspath, opts) :: result
  def post_file(path, fspath, opts \\ []) do
    handle_response(post(path, multipart(fspath), opts))
  end

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
    # FIXME: needs rework
    case response do
      {:ok, %Tesla.Env{status: 200, body: body}} -> {:ok, body}
      {:ok, %Tesla.Env{status: 500, body: body}} -> {:eserver, body}
      {:ok, %Tesla.Env{status: 400}} -> {:eclient, response}
      {:ok, %Tesla.Env{status: 403}} -> {:eaccess, response}
      {:ok, %Tesla.Env{status: 404}} -> {:emissing, response}
      {:ok, %Tesla.Env{status: 405}} -> {:enoallow, response}
      {:error, _} -> {:error, response}
    end
  end

  # Thanks to some forum :-)
  defp ls_r(path) do
    cond do
      File.regular?(path) ->
        [path]

      File.dir?(path) ->
        File.ls!(path)
        |> Enum.map(&Path.join(path, &1))
        |> Enum.map(&ls_r/1)
        |> Enum.concat()

      true ->
        []
    end
  end

  # This function is written explicitly to remove the base directory from the
  # file path. This is done so that the file path is relative to the base
  # directory. This is to avoid leaking irrelevant paths to the server.
  defp multipart_add_file(mp, fspath, basedir) do
    with relative_filename = String.replace(fspath, basedir <> "/", "") do
      Multipart.add_file(mp, fspath,
        name: "file",
        filename: "#{relative_filename}",
        detect_content_type: true
      )
    end
  end

  defp multipart_add_files(multipart, fspath) do
    with basedir = Path.dirname(fspath) do
      ls_r(fspath)
      |> Enum.reduce(multipart, fn fspath, multipart ->
        multipart_add_file(multipart, fspath, basedir)
      end)
    end
  end

  defp multipart(fspath) do
    Multipart.new()
    |> multipart_add_files(fspath)
  end
end
