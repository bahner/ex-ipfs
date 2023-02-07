defmodule MyspaceIPFS.BlockKeySizeTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias MyspaceIPFS.BlockKeySize, as: KeySize

  test "fails on missing data" do
    catch_error(%KeySize{} = KeySize.new())
  end

  test "create new KeySize" do
    data = %{"Key" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N", "Size" => 1}

    assert %KeySize{} = KeySize.new(data)
    key_size = KeySize.new(data)
    assert key_size.key == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert key_size.size == 1
  end
end
