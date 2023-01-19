defmodule MyspaceIPFS.Utils do
  @moduledoc """
  Some common functions that are used throughout the library.
  """

  @type fspath :: MyspaceIPFS.fspath()
  @typep response :: Tesla.Env.t()
  @typep okmapped :: MyspaceIPFS.okmapped()

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
    |> Enum.filter(fn x -> not Enum.member?(x, ["", nil, [], {}]) end)
  end

  @doc """
  Extracts the data from a response. Given a response, it will structure the
  data in a way that is easier to work with. IPFS only sends strings. This
  function will convert the string to a list of maps.
  """
  @spec handle_plain_response({:ok, response}) :: okmapped
  def handle_plain_response({:ok, response}) do
    with {_, tokens, _} <- :lexer.string(~c'#{response}') do
      if tokens == [] do
        {:ok, []}
      else
        tokens
        # The parser returns a tuple, which means okify() is not needed.
        |> :parser.parse()
      end
    end
  end

  # NB: There be dragons in here. This feels like a kludge.
  # But this is a chokepoint for all the errors so it's probably fine
  # and can be refactored later.
  # The error response when status code is 500 can contain important
  # information. This function will extract that information and return
  # it as a tuple.
  @doc false
  @spec handle_plain_response({atom, binary}) :: any
  def handle_plain_response({:eserver, response}) do
    with {_, tokens, _} <- :lexer.string(~c'#{response}') do
      if tokens == [] do
        {:ok, []}
      else
        tokens
        |> :parser.parse()
        |> (fn {_, data} -> {data} end).()
        |> Tuple.to_list()
        |> List.first()
        |> List.first()
        |> (fn data -> {:eserver, data} end).()
      end
    end
  end

  @spec handle_plain_response(binary) :: any
  def handle_plain_response(response) do
    {error, {:ok, tesla_response}} = response
    {error, tesla_response}
  end

  @doc false
  @spec handle_json_response({:ok, response}) :: okmapped
  def handle_json_response({:ok, response}) do
    response
    |> Jason.decode!()
    |> okify()
  end

  @doc false
  @spec handle_json_response({atom, binary}) :: any
  def handle_json_response({error, response}) do
    handle_plain_response({error, response})
  end

  @doc false
  # This function could be overloaded to extract data from response.
  @spec handle_file_response({:ok, binary}, fspath) :: okmapped
  def handle_file_response({:ok, response}, output) do
    File.write!(output, response)
    {:ok, output}
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
  def okify({:error, _} = err), do: err
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

  @doc false
  @spec write_temp_file(binary, fspath) :: {:ok, fspath}
  def write_temp_file(data, dir \\ "/tmp") do
    with dir <- mktempdir(dir),
         name <- Nanoid.generate(),
         file <- dir <> "/" <> name do
      File.write!(file, data)
      {:ok, file}
    end
  end

  @doc false
  @spec mktempdir(binary) :: binary
  def mktempdir(parent_dir) do
    with dir <- Nanoid.generate(),
         dir_path <- parent_dir <> "/myspace-" <> dir do
      File.mkdir_p(dir_path)
      dir_path
    end
  end

  @doc """
  Removes a temporary file. To be used in a pipe, and hence returns the data sent to it.
  """
  def remove_temp_file(data, file) do
    File.rm_rf!(file)
    data
  end
end
