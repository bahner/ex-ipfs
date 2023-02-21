defmodule ExIPFS.FilesStatTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.FilesStat, as: FilesStat

  @stat %{"Blocks" => 1, "CumulativeSize" => 2, "Hash" => "hash", "Size" => 3, "Type" => "type"}

  test "fails on missing data" do
    catch_error(%FilesStat{} = FilesStat.new())
  end

  test "test creation of stat" do
    assert %FilesStat{} = FilesStat.new(@stat)
    s = FilesStat.new(@stat)
    assert s.blocks == 1
    assert s.cumulative_size == 2
    assert s.hash == "hash"
    assert s.size == 3
    assert s.type == "type"
  end
end
