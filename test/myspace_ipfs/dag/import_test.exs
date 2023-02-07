defmodule MyspaceIPFS.DagImportTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias MyspaceIPFS.DagImport, as: DagImport

  test "fails on missing data" do
    catch_error(%DagImport{} = DagImport.new())
  end

  test "create new DagImport" do
    data = [
      %{
        "Root" => %{
          "Cid" => %{/: "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"},
          "PinErrorMsg" => "foo"
        }
      },
      %{"Stats" => %{"BlockBytesCount" => "213", "BlockCount" => "1"}}
    ]

    assert %DagImport{} = DagImport.new(data)
    import = DagImport.new(data)

    assert import.root.cid == %MyspaceIPFS.SlashCID{
             /: "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
           }

    assert import.root.pin_error_msg == "foo"
    assert import.stats.block_bytes_count == "213"
    assert import.stats.block_count == "1"
  end

  test "handles error data" do
    data = %{
      "Message" => "this is an error",
      "Code" => 0
    }

    assert {:error, data} = DagImport.new({:error, data})
    assert data == %{"Code" => 0, "Message" => "this is an error"}
  end
end
