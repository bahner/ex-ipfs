defmodule MyspaceIPFS.FilesEntriesTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias MyspaceIPFS.FilesEntries, as: FilesEntries

  @entries %{
    "Entries" => [
      %{
        "Hash" => "hash",
        "Name" => "name",
        "Size" => "size",
        "Type" => "type"
      }
    ]
  }

  test "fails on missing data" do
    catch_error(%FilesEntries{} = FilesEntries.new())
  end

  test "test creation of entries" do
    assert %FilesEntries{} = FilesEntries.new(@entries)
    e = FilesEntries.new(@entries)

    assert e.entries == [
             %MyspaceIPFS.FilesEntry{
               hash: "hash",
               name: "name",
               size: "size",
               type: "type"
             }
           ]
  end
end
