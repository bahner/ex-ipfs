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

  Some code based on https://github.com/tableturn/ipfs/blob/master/lib/ipfs.ex
  """
  use Tesla, docs: false
  alias Tesla.Multipart
  import MyspaceIPFS.Utils, only: [map_response_data: 1]

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
  plug(Tesla.Middleware.JSON)

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

  defp handle_response(response) do
    case response do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        {:ok, body}

      # When Tesla can't decode the response body because it's not JSON
      # it returns an error map. We need to handle this case, because
      # the IPFS API returns a lot of non-JSON responses.
      {:error, {Tesla.Middleware.JSON, :decode, %Jason.DecodeError{data: data}}} ->
        {:ok, map_response_data(data)}

      {:ok, response} ->
        response
    end
  end

  def multipart(fspath) do
    Multipart.new()
    |> Multipart.add_file(fspath,
      name: "file",
      filename: "#{fspath}",
      detect_content_type: true
    )
  end
end
