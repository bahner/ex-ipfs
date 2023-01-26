defmodule MyspaceIpfs.Utils do
  @moduledoc """
  Some common functions that are used throughout the library.
  """

  require Logger
  alias Tesla.Multipart

  @type fspath :: MyspaceIpfs.fspath()

  @doc """
  Converts a string to a boolean or integer or vise versa
  """
  def str2bool!("true"), do: true
  def str2bool!("false"), do: false

  @doc """
  Filter out any empty values from a list.
  Removes nil, {}, [], and "".
  """
  @spec filter_empties(list) :: list
  def filter_empties(list) do
    list
    |> Enum.reject(fn x -> Enum.member?(["", nil, [], {}], x) end)
  end

  @doc """
  IPFS api sometimes return invalid json. Instead of one json object, it returns
  multiple json objects separated by newlines. This function will convert the
  string to a list of maps.

  If it fails, it'll just return the original string.
  """
  @spec extract_data_from_json_error(any) :: list | binary
  def extract_data_from_json_error(error) do
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

  @spec timestamp :: integer
  @doc """
  Returns the current timestamp in unix time.
  """
  def timestamp() do
    DateTime.utc_now()
    |> DateTime.to_unix()
  end

  @doc """
  Returns the current timestamp in iso8601 format.
  """
  @spec timestamp(:iso) :: binary
  def timestamp(:iso) do
    DateTime.utc_now()
    |> DateTime.to_iso8601()
  end

  @doc """
  Wraps the data in an elixir standard response tuple.
  {:ok, data} or {:error, data}
  """
  @spec okify(any) :: {:ok, any} | {:error, any}
  def okify({:error, data}), do: {:error, data}
  def okify(res), do: {:ok, res}

  @doc """
  Unlists a list if it only contains one element.
  """
  @spec unlist(list) :: any
  def unlist(list) do
    case list do
      [x] -> x
      _ -> list
    end
  end

  @doc """
  Creates a unique file in the given directory and returns the path.

  Path defaults to "/tmp" if not given.
  """
  @spec write_temp_file(binary, fspath) :: {:ok, fspath}
  def write_temp_file(data, dir \\ "/tmp") do
    with dir <- mktempdir(dir),
         name <- Nanoid.generate(),
         file <- dir <> "/" <> name do
      File.write!(file, data)
      {:ok, file}
    end
  end

  @doc """
  Creates a unique directory in the given directory and returns the path.
  The directory name will be prefixed with "myspace-". This way you can easily remove
  all the temporary directories created by this function.
  """
  @spec mktempdir(fspath) :: binary
  def mktempdir(parent_dir) do
    dir_path = "#{parent_dir}/myspace-#{Nanoid.generate()}"
    File.mkdir_p(dir_path)
    dir_path
  end

  @doc """
  A simple function to extract the data from a tuple.

  ## Examples

  iex> MyspaceIpfs.Utils.unokify({:ok, "data"})
  "data"
  """
  @spec unokify({:ok, any}) :: any
  def unokify({:ok, data}) do
    data
  end

  @doc """
  Recase the headers to snake or kebab case. The headers from tesla is a list of tuples.
  So some sugar to make it easier to work with.
  The default is snake case.

  The use for this is to make it easier to pattern match on headers.

  ## Parameters

  - headers: A list of tuples. The first element is the header name, the second is the value.
  - format: The format to convert the headers to. Either :snake or :kebab.

  ## Examples

  iex> headers = [{"Content-Type", "application/json"}, {"X-My-Header", "value"}]
  iex> MyspaceIpfs.Utils.recase_headers(headers, :kebab)
  [{"content-type", "application/json"}, {"x-my-header", "value"}]

  iex> headers = [{"Content-Type", "application/json"}, {"X-My-Header", "value"}]
  iex> MyspaceIpfs.Utils.recase_headers(headers, :snake)
  [{"content_type", "application/json"}, {"x_my_header", "value"}]

  """
  @spec recase_headers(list, :kebab | :snake) :: list
  def recase_headers(headers, format \\ :snake) when is_list(headers) do
    case format do
      :snake -> Enum.map(headers, fn {k, v} -> {Recase.to_snake(k), v} end)
      :kebab -> Enum.map(headers, fn {k, v} -> {Recase.to_kebab(k), v} end)
    end
  end

  @doc """
  Get a response header from a list of headers.
  Tesla sends the headers as a list of tuples. This function makes it easier to get a header.

  To do this recases the headers to snake case and then converts the list to a map.
  This way you don't need to be concerned about the casing of the header name.

  ## Parameters

  - headers: A list of tuples. The first element is the header name, the second is the value.
  - key: The name of the header to get the value for.
  """
  @spec get_header_value(list, binary) :: binary
  def get_header_value(headers, key) do
    # Here it's important to recase the key to snake case both for the key and the headers.
    key = Recase.to_snake(key)

    headers
    |> Enum.into(%{})
    |> Recase.Enumerable.convert_keys(&Recase.to_snake/1)
    |> Map.get(key)
  end

  @doc """
  Adds a file to the multipart request.
  This function is written explicitly to remove the base directory from the
  file path.

  This pattern is used in the IPFS API. The file path is relative to the
  base directory. This is to avoid leaking irrelevant paths to the server.
  """
  @spec multipart_add_file(Multipart.t(), fspath, fspath) :: Multipart.t()
  def multipart_add_file(mp, fspath, basedir) do
    relative_filename = String.replace(fspath, basedir <> "/", "")

    Multipart.add_file(mp, fspath,
      name: "file",
      filename: relative_filename,
      detect_content_type: true
    )
  end

  @doc """
  Creates a multipart request from a file path. This takes care of adding all the files
  in the directory recursively.
  """
  @spec multipart(fspath) :: Multipart.t()
  def multipart(fspath) do
    Multipart.new()
    |> multipart_add_files(fspath)
  end

  @doc """
  Creates a multipart request from a binary. The filename should always be "file". Because
  the IPFS API expects this.
  """
  @spec multipart_content(binary) :: Multipart.t()
  def multipart_content(data) do
    Multipart.new()
    |> Multipart.add_file_content(data, "file")
  end

  @doc """
  Adds a directory to a multipart request. This takes care of adding all the files
  in the directory recursively.

  The underlying add function clears away the parent directory from the file path.
  This way your don't reveal the full path to the server, just the last leg of the path.
  Eg. myspace from /var/tmp/myspace.

  ## Parameters

    - multipart: The multipart request to add the files to.
    - fspath: The path to the directory to add to the multipart request.
  """
  def multipart_add_files(multipart, fspath) do
    with basedir <- Path.dirname(fspath) do
      ls_r(fspath)
      |> Enum.reduce(multipart, fn fspath, multipart ->
        multipart_add_file(multipart, fspath, basedir)
      end)
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

  @doc """
  Converts JSON key strings to snake cased atoms. If action fails, it just passes on the data.
  """
  @spec snake_atomize({:error, any} | map) :: map | {:error, any}

  @spec snake_atomize({:error, any}) :: {:error, any}
  def snake_atomize({:error, data}) do
    {:error, data}
  end

  def snake_atomize(map) do
    try do
      map
      |> Recase.Enumerable.convert_keys(&Recase.to_snake/1)
      |> Recase.Enumerable.convert_keys(&String.to_existing_atom/1)
    catch
      _ -> map
    end
  end

  @doc """
  Starts a stream client and returns a reference to the client.
  ## Parameters
    - pid: The pid to stream the data to.
    - url: The url to stream the data from.
    - timeout: The timeout for the stream. Defaults to infinity.
    - query_options: A list of query options to add to the url.
  """
  @spec spawn_client(pid, binary, :atom | integer, list) :: reference
  def spawn_client(pid, url, timeout \\ :infinity, query_options \\ []) do
    Logger.debug("Starting stream client for #{url} with query options #{inspect(query_options)}")
    options = [stream_to: pid, async: true, recv_timeout: timeout, query: query_options]
    :hackney.request(:post, url, [], <<>>, options)
  end

  @doc """
  Generates a key size struct from a map.
  """
  @spec gen_key_size({:error, any} | map) :: struct | {:error, any}
  def gen_key_size({:error, data}) do
    {:error, data}
  end

  def gen_key_size(opts) when is_map(opts) do
    %MyspaceIpfs.KeySize{} |> struct!(opts)
  end

  @doc """
  Generates a key value struct from a map.
  """
  @spec gen_key_value({:error, any} | map) :: struct | {:error, any}
  def gen_key_value({:error, data}) do
    {:error, data}
  end

  def gen_key_value(opts) when is_map(opts) do
    %MyspaceIpfs.KeyValue{} |> struct!(opts)
  end

  @doc """
  Generates a peers struct from a map.
  """
  @spec gen_peers({:error, any} | map) :: struct | {:error, any}
  def gen_peers({:error, data}) do
    {:error, data}
  end

  def gen_peers(opts) when is_map(opts) do
    %MyspaceIpfs.Peers{} |> struct!(opts)
  end

  @doc """
  Generates an IPFS API Hash struct from a map.
  """
  @spec gen_hash({:error, any} | map) :: struct | {:error, any}
  def gen_hash({:error, data}) do
    {:error, data}
  end

  def gen_hash(opts) when is_map(opts) do
    %MyspaceIpfs.Hash{} |> struct!(opts)
  end

  @doc """
  Returns the data in an {:error, tuple}
  """
  @spec errify(any) :: {:error, any}
  def errify(data) do
    {:error, data}
  end
end
