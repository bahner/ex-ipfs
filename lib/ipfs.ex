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

  # Code taken based on https://github.com/tableturn/ipfs/blob/master/lib/ipfs.ex
  """
  use Tesla
  alias Tesla.Multipart

  @typedoc "Represents an endpoint path to hit."
  @type path :: String.t()
  @typedoc "Identifies content on the IPFS network using a multihash string."
  @type cid :: String.t()
  @typedoc "Represents an absolute filename existing on disk."
  @type filename :: String.t()
  @typedoc "Models the result of most of the functions accessible in this module."
  @type result :: {:ok, any} | {:error, any}

  @baseurl Application.get_env(:myspace_ipfs, :baseurl)

  # Connection manager.

  plug(Tesla.Middleware.BaseUrl, @baseurl)
  plug(Tesla.Middleware.Logger)
  plug(Tesla.Middleware.JSON)

  @doc """
  High level function allowing to perform POST requests to the node.
  A `path` has to be provided, along with an optional list of `params` that are
  dependent on the endpoint that will get hit.
  NB! This is not a GET request, but a POST request. IPFS uses POST requests.
  """
  @spec post_query(path, list) :: result
  def post_query(path, params \\ []) do
    handle_response(post(@baseurl <> path, "", params))
  end

  @doc """
  POST request without JSON Middleware.
  """
  @spec post_query_plain(path, list) :: result
  def post_query_plain(path, params \\ []) do
    handle_response(Tesla.post(@baseurl <> path, "", params))
  end

  @doc """
  High level function allowing to send file contents to the node.
  A `path` has to be specified along with the `filename` to be sent. Also, a list
  of `params` can be optionally sent.
  """
  def post_file(path, filename, params \\ []) do
    handle_response(post(path, multipart(filename), params))
  end

  defp multipart(filename) do
    Multipart.new()
    |> Multipart.add_file(filename,
      name: "\" file \"",
      filename: "\"" <> filename <> "\"",
      detect_content_type: true
    )
  end

  defp handle_response(response) do
    case response do
      {:ok, %Tesla.Env{status: 200, body: body}} -> body
      {:ok, %Tesla.Env{status: 404}} -> {:error, response}
      {:error, response} -> response
    end
  end
end
