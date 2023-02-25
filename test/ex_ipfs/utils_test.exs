defmodule ExIpfs.UtilsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExUnit.DocTest
  alias ExIpfs.Utils

  DocTest.doctest(ExIpfs.Utils)

  @headers [
    {"content_type", "application/json"},
    {"x_ipfs_path", "/ipfs/QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXj9R1o1rTm7N"}
  ]

  test "now creates a binary timestamp" do
    assert is_integer(Utils.timestamp())
  end

  test "now creates a timestamp larger than ... now()" do
    assert Utils.timestamp() > 1_677_020_518
  end

  test "timestamp creates a iso8601 timestamp" do
    assert is_binary(Utils.timestamp(:iso))
    assert String.length(Utils.timestamp(:iso)) == 27
    assert String.ends_with?(Utils.timestamp(:iso), "Z")
  end

  test "creates timestamp that can be converted back to a datetime" do
    assert DateTime.from_unix(Utils.timestamp()) != {:error, "Invalid date"}
  end

  test "okify returns {:ok, data} when given {:ok, data}" do
    assert Utils.okify("data") == {:ok, "data"}
  end

  test "okicy passes on :ok tuple" do
    assert Utils.okify({:ok, "data"}) == {:ok, "data"}
  end

  test "str2bool! returns true when given \"true\"" do
    assert Utils.str2bool!("true") == true
  end

  test "str2bool! returns false when given \"false\"" do
    assert Utils.str2bool!("false") == false
  end

  test "filter_empties returns an empty list when given an empty list" do
    list_with_empty = ["", nil, [], {}, "data"]
    assert Utils.filter_empties([]) == []
    assert Utils.filter_empties(list_with_empty) == ["data"]
  end

  test "filter_empties passes on error data" do
    assert Utils.filter_empties({:error, "data"}) == {:error, "data"}
  end

  test "unlist returns the data if it is not a list" do
    assert Utils.unlist(["data"]) == "data"
  end

  test "unokify returns the data if it is not a tuple" do
    assert Utils.unokify({:ok, "data"}) == "data"
  end

  test "unlist passes through non list" do
    assert Utils.unlist("data") == "data"
  end

  test "recase_headers returns a map with the headers in the correct case" do
    [recased_header | tail] = Utils.recase_headers(@headers)
    assert recased_header == {"content_type", "application/json"}
    assert tail == [{"x_ipfs_path", "/ipfs/QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXj9R1o1rTm7N"}]
  end

  test "assert get_header_value gets correct value" do
    assert Utils.get_header_value(@headers, "content_type") == "application/json"
  end

  test "assert get_header_value returns nil if header is not found" do
    assert Utils.get_header_value(@headers, "foo") == nil
  end

  test "multipart returns a multipart body" do
    assert %Tesla.Multipart{} = Utils.multipart("data")
  end

  test "multipart fails for non-binary data" do
    assert catch_error(Utils.multipart(:atom))
    assert catch_error(Utils.multipart([]))
    assert catch_error(Utils.multipart(%{}))
    assert catch_error(Utils.multipart(nil))
  end

  test "multipart_content returns a multipart body" do
    assert %Tesla.Multipart{} = Utils.multipart_content("data")
  end

  test "multipart_content fails for non-binary data" do
    assert catch_error(Utils.multipart_content(:atom))
    assert catch_error(Utils.multipart_content([]))
    assert catch_error(Utils.multipart_content(%{}))
    assert catch_error(Utils.multipart_content(nil))
  end

  test "multipart_add_files adds files to a multipart body" do
    Temp.track!()
    multipart = Utils.multipart("data")
    {_pid, tmpfile} = Temp.open!("foo")

    assert %Tesla.Multipart{} = Utils.multipart_add_files(multipart, tmpfile)

    multipart = Utils.multipart_add_files(multipart, tmpfile)
    assert is_list(multipart.parts)
    assert %Tesla.Multipart.Part{} = List.last(multipart.parts)
  end

  test "struct2json! returns a json string" do
    {:ok, struct} = ExIpfs.id()
    assert is_binary(Utils.struct2json!(struct))
  end
end
