defmodule MyspaceIPFS.AddResultTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias MyspaceIPFS.AddResult

  describe "new/1" do
    test "returns a struct" do
      assert %AddResult{} = AddResult.new(%{})
    end

    test "returns a list of structs" do
      assert [%AddResult{}] = AddResult.new([%{}])
    end

    test "returns an error tuple" do
      assert {:error, "error"} = AddResult.new({:error, "error"})
    end
  end
end
