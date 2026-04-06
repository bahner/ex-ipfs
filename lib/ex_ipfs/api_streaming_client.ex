defmodule ExIpfs.ApiStreamingClient do
  @moduledoc """
  An http client to handle streaming data from the IPFS API.
  """

  require Logger

  @doc """
  Starts a stream client and returns a reference to the client.

  ## Parameters
  - pid: The pid to stream the data to.
  - url: The full RPC URL to stream from.
  - timeout: Finch `receive_timeout` in milliseconds or `:infinity`.
  - query_options: Keyword list of query options merged into the URL query string.
  """
  @spec new(pid, binary) :: {:ok, pid()} | {:error, term()}
  @spec new(pid, binary, :infinity | integer) :: {:ok, pid()} | {:error, term()}
  @spec new(pid, binary, :infinity | integer, list) :: {:ok, pid()} | {:error, term()}
  def new(pid, url, timeout \\ :infinity, query_options \\ []) do
    Logger.debug(
      # coveralls-ignore-next-line
      "Starting IPFS API stream client for #{url} with query options #{inspect(query_options)}"
    )

    full_url = merge_query_options(url, query_options)

    Task.start(fn ->
      request = Finch.build(:post, full_url)

      case Finch.stream(request, ExIpfs.Finch, nil, &forward_chunk(pid, &1, &2),
             receive_timeout: timeout
           ) do
        {:ok, _acc} ->
          send(pid, {:finch_response, :done})
          :ok

        {:error, reason, _acc} ->
          send(pid, {:finch_response, {:error, reason}})
          {:error, reason}
      end
    end)
  end

  defp forward_chunk(pid, chunk, acc) do
    message =
      case chunk do
        {:status, status} -> {:status, status}
        {:headers, headers} -> {:headers, headers}
        {:data, data} -> data
        {:trailers, trailers} -> {:trailers, trailers}
      end

    send(pid, {:finch_response, message})
    {:cont, acc}
  end

  defp merge_query_options(url, []), do: url

  defp merge_query_options(url, query_options) do
    uri = URI.parse(url)

    merged_query =
      uri.query
      |> to_query_map()
      |> Map.merge(Map.new(query_options))
      |> URI.encode_query()

    URI.to_string(%URI{uri | query: merged_query})
  end

  defp to_query_map(nil), do: %{}
  defp to_query_map(query), do: URI.decode_query(query)
end
