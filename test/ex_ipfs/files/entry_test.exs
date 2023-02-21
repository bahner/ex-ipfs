defmodule ExIPFS.FilesEntryTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.FilesEntry, as: FilesEntry

  @entry %{
    "Hash" => "hash",
    "Name" => "name",
    "Size" => "size",
    "Type" => "type"
  }

  test "fails on missing data" do
    catch_error(%FilesEntry{} = FilesEntry.new())
  end

  test "test creation of entry" do
    assert %FilesEntry{} = FilesEntry.new(@entry)
    e = FilesEntry.new(@entry)
    assert e.hash == "hash"
    assert e.name == "name"
    assert e.size == "size"
    assert e.type == "type"
  end
end
