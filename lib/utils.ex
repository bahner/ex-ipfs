defmodule MyspaceIPFS.Utils do
  @moduledoc """
  Some common functions that are used throughout the library.
  """

  @type fspath :: MyspaceIPFS.fspath()
  @doc """
  Filter out any empty values from a list.
  Removes nil, {}, [], and "".
  """
  @spec filter_empties(list) :: list
  def filter_empties(list) do
    list
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.filter(fn x -> x != {} end)
    |> Enum.filter(fn x -> x != [] end)
    |> Enum.filter(fn x -> x != "" end)
  end

  @doc """
  Extracts the data from a response. Given a response, it will structure the
  data in a way that is easier to work with. IPFS only sends strings. This
  function will convert the string to a list of maps.
  """
  @spec map_response_data(any) :: any
  def map_response_data(response) do
    with {_, tokens, _} <- :lexer.string(~c'#{response}') do
      tokens
      |> :parser.parse()
    end
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
  @spec write_tmpfile(binary, fspath) :: binary
  def write_tmpfile(data, dir \\ "/tmp") do
    with dir <- mktempdir(dir),
         name <- Nanoid.generate(),
         file <- dir <> "/" <> name do
      File.write!(file, data)
      file
    end
  end

  @spec mktempdir(binary) :: binary
  @doc false
  def mktempdir(parent_dir) do
    with dir <- Nanoid.generate(),
         dir_path <- parent_dir <> "/myspace-" <> dir do
      File.mkdir_p(dir_path)
      dir_path
    end
  end
end
