defmodule ExIpfs.Utils do
  @moduledoc false

  require Logger
  alias Tesla.Multipart

  @doc """
  Returns the data in an {:error, tuple}
  """
  @spec errify(any) :: {:error, any}
  def errify(data) do
    {:error, data}
  end

  @doc """
  Filter out any empty values from a list.
  Removes nil, {}, [], and "".
  """
  # @spec filter_empties(list | map | {:error, any}) :: list | map | {:error, any}
  @spec filter_empties(any) :: any
  def filter_empties(data) do
    case data do
      {:error, data} -> {:error, data}
      [] -> []
      _ -> Enum.reject(data, fn x -> Enum.member?(["", nil, [], {}], x) end)
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
  Creates a multipart request from a file path. This takes care of adding all the files
  in the directory recursively.
  """
  @spec multipart(Path.t()) :: Multipart.t()
  def multipart(fspath) when is_binary(fspath) do
    Multipart.new()
    |> multipart_add_files(fspath)
  end

  @doc """
  Adds a file to the multipart request.
  This function is written explicitly to remove the base directory from the
  file path.

  This pattern is used in the IPFS API. The file path is relative to the
  base directory. This is to avoid leaking irrelevant paths to the server.
  """
  @dialyzer {:no_return, multipart_add_file: 3}
  @spec multipart_add_file(Multipart.t(), Path.t(), Path.t()) :: Multipart.t()
  def multipart_add_file(mp, fspath, basedir) do
    relative_filename = String.replace(fspath, basedir <> "/", "")

    Multipart.add_file(mp, fspath,
      name: "file",
      filename: relative_filename,
      detect_content_type: true
    )
  end

  @doc """
  Creates a multipart request from a binary. The filename should always be "file". Because
  the IPFS API expects this.
  """
  @spec multipart_content(binary) :: Tesla.Multipart.t()
  @spec multipart_content(binary, binary) :: Multipart.t()
  def multipart_content(data, type \\ "file") when is_binary(data) and is_binary(type) do
    Multipart.new()
    |> Multipart.add_file_content(data, type)
  end

  @doc """
  Adds a directory to a multipart request. This takes care of adding all the files
  in the directory recursively.

  The underlying add function clears away the parent directory from the file path.
  This way your don't reveal the full path to the server, just the last leg of the path.
  Eg. ex from /var/tmp/ex.

  ## Parameters

    - multipart: The multipart request to add the files to.
    - fspath: The path to the directory to add to the multipart request.
  """
  @dialyzer {:no_return, multipart_add_files: 2}
  @spec multipart_add_files(Multipart.t(), Path.t()) :: Multipart.t()
  def multipart_add_files(multipart, fspath) do
    with basedir <- Path.dirname(fspath) do
      ls_r(fspath)
      |> Enum.reduce(multipart, fn fspath, multipart ->
        multipart_add_file(multipart, fspath, basedir)
      end)
    end
  end

  @doc """
  Wraps the data in an elixir standard response tuple.
  {:ok, data} or {:error, data}
  """
  @spec okify(any) :: {:ok, any} | {:error, any}
  def okify(input) do
    case input do
      {:ok, data} -> {:ok, data}
      {:error, data} -> {:error, data}
      _ -> {:ok, input}
    end
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
  Recase the headers to snake or kebab case. The headers from tesla is a list of tuples.
  So some sugar to make it easier to work with.
  The default is snake case.

  The use for this is to make it easier to pattern match on headers.

  ## Parameters

  - headers: A list of tuples. The first element is the header name, the second is the value.
  - format: The format to convert the headers to. Either :snake or :kebab.

  ## Examples

  iex> headers = [{"Content-Type", "application/json"}, {"X-My-Header", "value"}]
  iex> ExIpfs.Utils.recase_headers(headers, :kebab)
  [{"content-type", "application/json"}, {"x-my-header", "value"}]

  iex> headers = [{"Content-Type", "application/json"}, {"X-My-Header", "value"}]
  iex> ExIpfs.Utils.recase_headers(headers, :snake)
  [{"content_type", "application/json"}, {"x_my_header", "value"}]

  """
  @spec recase_headers(list()) :: list()
  @spec recase_headers(list, :kebab | :snake) :: list
  def recase_headers(headers, format \\ :snake) when is_list(headers) do
    case format do
      :snake -> Enum.map(headers, fn {k, v} -> {Recase.to_snake(k), v} end)
      :kebab -> Enum.map(headers, fn {k, v} -> {Recase.to_kebab(k), v} end)
    end
  end

  @doc """
  Converts a string to a boolean or integer or vise versa
  """
  @spec str2bool!(<<_::32, _::_*8>>) :: boolean
  def str2bool!("true"), do: true
  def str2bool!("false"), do: false

  @doc """
  Converts a struct to a map to a JSON string.

  There is no obvious reverse function for this. The reason is that the struct
  can contain functions. So the reverse function would have to be aware of the
  struct and remove the functions. This is not possible in a generic way.
  """
  @spec struct2json!(struct) :: binary
  def struct2json!(struct) do
    struct
    |> Map.from_struct()
    |> JSON.encode!()
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
  A simple function to extract the data from a tuple.

  ## Examples

  iex> ExIpfs.Utils.unokify({:ok, "data"})
  "data"
  iex> ExIpfs.Utils.unokify({:error, "data"})
  {:error, "data"}

  """
  @spec unokify(any) :: {:ok, any} | nil
  def unokify(data) do
    case data do
      {:ok, data} -> data
      _ -> data
    end
  end

  def map_has_keys?(response, expected_keys) do
    if Enum.all?(expected_keys, &Map.has_key?(response, &1)) do
      response
    else
      raise ArgumentError,
        message: "Missing some of #{inspect(expected_keys)} in response from IPFS API"
    end
  end

  def map_get_key!(response, key) do
    case response do
      %{^key => value} ->
        value

      _ ->
        raise ArgumentError,
          message: "Problem extracting #{inspect(key)} from response from IPFS API"
    end
  end
end
