defmodule MyspaceIPFS.Utils do
  @moduledoc """
  Some common functions that are used throughout the library.
  """

  @type fspath :: MyspaceIPFS.fspath()
  @typep response :: Tesla.Env.t()
  @typep okmapped :: MyspaceIPFS.okmapped()

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
  @spec handle_response_data({:ok, response}) :: okmapped
  def handle_response_data({:ok, response}) do
    with {_, tokens, _} <- :lexer.string(~c'#{response}') do
      if tokens == [] do
        {:ok, []}
      else
        tokens
        |> :parser.parse()
      end
    end
  end

  # NB: There be dragons in here. This feels like a kludge.
  # But this is a chokepoint for all the errors so it's probably fine
  # and can be refactored later.
  @spec handle_response_data({atom, binary}) :: any
  def handle_response_data({error, response}) do
    with {_, tokens, _} <- :lexer.string(~c'#{response}') do
      if tokens == [] do
        {:ok, []}
      else
        tokens
        |> :parser.parse()
        |> then(fn {_, data} -> {data} end)
        |> Tuple.to_list()
        |> List.first()
        |> List.first()
        |> then(fn data -> {error, data} end)
      end
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
