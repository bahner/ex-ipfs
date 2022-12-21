defmodule MyspaceIPFS.Utils do
  @moduledoc """
  MyspaceIPFS.Utils is a collection of helper functions for the MyspaceIPFS library.
  """

  @spec map_response_data(any) :: list
  def map_response_data(response) do
    extract_data_from_plain_response(response)
    |> convert_list_of_tuples_to_map()
  end

  # Private functions
  defp extract_data_from_plain_response(binary) do
    binary
    |> split_string_by_newline()
    |> filter_empties()
    |> Enum.map(fn x -> extract_tuples_from_string(x) end)
  end

  defp convert_list_of_tuples_to_map(list) do
    list
    |> Enum.map(fn x -> list_of_tuples_to_map(x) end)
  end

  defp filter_empties(list) do
    list
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.filter(fn x -> x != {} end)
    |> Enum.filter(fn x -> x != [] end)
    |> Enum.filter(fn x -> x != "" end)
  end

  defp split_string_by_newline(string) do
    Regex.split(~r/\n/, string)
  end

  defp split_string_by_comma(string) do
    Regex.split(~r/,/, string)
  end

  defp extract_tuples_from_string(string) do
    string
    |> split_string_by_comma()
    |> filter_empties()
    |> Enum.map(fn x -> tuplestring_to_tuple(x) end)
  end

  defp get_value_from_string(string) do
    # IO.puts("ValueString: #{string}")
    with data = Regex.run(~r/:"(.+?)"/, string),
         true <- not is_nil(data) do
      Enum.at(data, 1)
    else
      _ -> ""
    end
  end

  defp get_name_from_string(string) do
    # IO.puts("NameString: #{string}")
    with data = Regex.run(~r/"(.+?)":/, string),
         true <- not is_nil(data) do
      Enum.at(data, 1)
    else
      _ -> ""
    end
  end

  defp tuplestring_to_tuple(string) do
    {get_name_from_string(string), get_value_from_string(string)}
  end

  def list_of_tuples_to_map(list) do
    list
    |> Enum.into(%{})
  end
end
