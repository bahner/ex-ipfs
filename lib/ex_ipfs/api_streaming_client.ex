defmodule ExIpfs.ApiStreamingClient do
  @moduledoc """
  An http client to handle streaming data from the IPFS API.
  """

  require Logger

  @spec new(
          pid,
          binary,
          :infinity | integer,
          list
        ) :: {:error, any} | {:ok, any} | {:ok, integer, list} | {:ok, integer, list, any}
  @doc """
  Starts a stream client and returns a reference to the client.
  ## Parameters
  - pid: The pid to stream the data to.
  - url: The url to stream the data from.
  - timeout: The timeout for the stream. Defaults to infinity.
  - query_options: A list of query options to add to the url.
  """
  def new(pid, url, timeout \\ :infinity, query_options) do
    Logger.debug("Starting stream client for #{url} with query options #{inspect(query_options)}")
    options = [stream_to: pid, async: true, recv_timeout: timeout, query: query_options]
    :hackney.request(:post, url, [], <<>>, options)
  end
end
