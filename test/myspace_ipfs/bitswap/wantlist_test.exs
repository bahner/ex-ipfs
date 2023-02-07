defmodule MyspaceIPFS.Bitswap.WantListTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias MyspaceIPFS.BitswapWantList, as: Wantlist

  describe "new/1" do
    test "fails on no data a new wantlist" do
      catch_error(%Wantlist{} = Wantlist.new())
    end

    test "create new BitswapWantList" do
      data = %{
        "Keys" => ["QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"]
      }

      assert %Wantlist{} = Wantlist.new(data)
      wantlist = Wantlist.new(data)
      assert wantlist.keys == ["QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"]
    end

    test "handles error data" do
      data = %{
        "Message" => "this is an error",
        "Code" => 0
      }

      assert {:error, data} = Wantlist.new({:error, data})
    end
  end
end
