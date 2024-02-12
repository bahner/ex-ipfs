defmodule ExIpfs.CidBase32CIDTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIpfs.CidBase32CID, as: Base32CID

  test "fails on missing data" do
    catch_error(%Base32CID{} = Base32CID.new())
  end

  test "create new Base32CID" do
    data = %{
      "CidStr" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
      "Formatted" => "foo",
      "ErrorMsg" => "bar"
    }

    assert %Base32CID{} = Base32CID.new(data)
    base32_cid = Base32CID.new(data)
    assert base32_cid.cid_str == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert base32_cid.formatted == "foo"
    assert base32_cid.error_msg == "bar"
  end

  test "handles error data" do
    data = %{
      "Message" => "this is an error",
      "Code" => 0
    }

    assert {:error, _} = Base32CID.new({:error, data})
  end
end
