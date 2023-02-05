defmodule MyspaceIPFS.CidTest do
  @moduledoc """
  Test the MyspaceIPFS API

  This test suite is designed to test the MyspaceIPFS API. It is not designed to test the IPFS API
  itself. It is designed to test the MyspaceIPFS API wrapper. This test suite is designed to be run

  NB! The tests are not mocked. They are designed to be run against a live IPFS node. This is
  """
  use ExUnit.Case, async: true
  alias MyspaceIPFS.Cid

  test "check base32 conversion" do
    {:ok, cid} = Cid.base32("QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N")
    assert is_map(cid)
    assert %MyspaceIPFS.CidBase32CID{} = cid
    assert cid.cid_str == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert cid.formatted == "bafybeie5745rpv2m6tjyuugywy4d5ewrqgqqhfnf445he3omzpjbx5xqxe"
    assert cid.error_msg == ""
  end

  test "format returns the same for v0" do
    {:ok, cid} = Cid.format("QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N")
    assert is_map(cid)
    assert %MyspaceIPFS.CidBase32CID{} = cid
    assert cid.cid_str == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert cid.formatted == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert cid.error_msg == ""
  end

  test "format returns the same for v1" do
    {:ok, cid} = Cid.format("bafybeie5745rpv2m6tjyuugywy4d5ewrqgqqhfnf445he3omzpjbx5xqxe")
    assert is_map(cid)
    assert %MyspaceIPFS.CidBase32CID{} = cid
    assert cid.cid_str == "bafybeie5745rpv2m6tjyuugywy4d5ewrqgqqhfnf445he3omzpjbx5xqxe"
    assert cid.formatted == "bafybeie5745rpv2m6tjyuugywy4d5ewrqgqqhfnf445he3omzpjbx5xqxe"
    assert cid.error_msg == ""
  end

  test "format v1" do
    {:ok, cid} = Cid.format("QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N", v: 1)
    assert is_map(cid)
    assert %MyspaceIPFS.CidBase32CID{} = cid
    assert cid.cid_str == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert cid.formatted == "zdj7Wg4epE5TV2MzXASh5WY5EBarz9hAhno1FwJS2VtLBGrFJ"
    assert cid.error_msg == ""
  end

  test "format v0" do
    {:ok, cid} = Cid.format("bafybeie5745rpv2m6tjyuugywy4d5ewrqgqqhfnf445he3omzpjbx5xqxe", v: 0)
    assert is_map(cid)
    assert %MyspaceIPFS.CidBase32CID{} = cid
    assert cid.cid_str == "bafybeie5745rpv2m6tjyuugywy4d5ewrqgqqhfnf445he3omzpjbx5xqxe"
    assert cid.formatted == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert cid.error_msg == ""
  end
end
