defmodule MyspaceIPFS.Utils do
  @moduledoc """
  Some common functions that are used throughout the library.
  """

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
  @spec map_response_data(any) :: list
  def map_response_data(response) do
    extract_data_from_plain_response(response)
    |> filter_empties()
    |> convert_list_of_tuples_to_map()
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

  # Private functions

  defp convert_list_of_tuples_to_map(list) do
    list
    |> filter_empties()
    |> Enum.map(fn x -> list_of_tuples_to_map(x) end)
  end

  defp extract_data_from_plain_response(binary) do
    binary
    |> split_string_by_newline()
    |> filter_empties()
    |> Enum.map(fn x -> extract_tuples_from_string(x) end)
  end

  defp extract_tuples_from_string(string) do
    string
    |> split_string_by_comma()
    |> filter_empties()
    |> Enum.map(fn x -> tuplestring_to_tuple(x) end)
  end

  defp filter_empty_keys(map) do
    map
    |> Enum.reject(fn {x, _} -> is_nil(x) end)
    |> Enum.reject(fn {x, _} -> x == "" end)
  end

  defp get_value_from_string(string) do
    # IO.puts("ValueString: #{string}")
    with data = Regex.run(~r/:"(.+?)"/, string),
         true <- not is_nil(data) do
      Enum.at(data, 1)
    else
      _ -> nil
    end
  end

  defp get_name_from_string(string) do
    # IO.puts("NameString: #{string}")
    with data = Regex.run(~r/"(.+?)":/, string),
         true <- not is_nil(data) do
      Enum.at(data, 1)
    else
      _ -> nil
    end
  end

  defp list_of_tuples_to_map(list) do
    list
    |> filter_empties()
    |> Enum.into(%{})
    |> filter_empty_keys()
  end

  defp split_string_by_newline(string) do
    Regex.split(~r/\n/, string)
  end

  defp split_string_by_comma(string) do
    Regex.split(~r/,/, string)
  end

  defp tuplestring_to_tuple(string) do
    {get_name_from_string(string), get_value_from_string(string)}
  end
end
