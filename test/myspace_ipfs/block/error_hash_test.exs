defmodule MyspaceIPFS.BlockErrorHashTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias MyspaceIPFS.BlockErrorHash, as: ErrorHash

  describe "new/1" do
    test "fails on missing data" do
      catch_error(%ErrorHash{} = ErrorHash.new())
    end

    test "returns a new error hash with data" do
      data = %{
       "Hash" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
       "Error" => "this is an error"
      }

      assert %ErrorHash{} = ErrorHash.new(data)
      assert error_hash = ErrorHash.new(data)
      assert error_hash.hash == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
      assert error_hash.error == "this is an error"
    end

    test "handles error data" do
      data = %{
        "Message" => "this is an error",
        "Code" => 0
      }

      assert {:error, data} = ErrorHash.new({:error, data})
    end
  end
end
