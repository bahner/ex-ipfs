defmodule ExIPFS.BitswapLedgerTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.BitswapLedger, as: Ledger

  describe "new/1" do
    test "fails on no data for new ledger" do
      catch_error(%Ledger{} = Ledger.new())
    end

    test "returns a new ledger with data" do
      data = %{
        "Exchanged" => 1,
        "Peer" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
        "Recv" => 1,
        "Sent" => 1,
        "Value" => 1
      }

      assert %Ledger{} = Ledger.new(data)
      ledger = Ledger.new(data)
      assert ledger.exchanged == 1
      assert ledger.peer == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
      assert ledger.value == 1
      assert ledger.recv == 1
      assert ledger.sent == 1
    end

    test "error data" do
      data = %{
        "Message" => "this is an error",
        "Code" => 0
      }

      assert {:error, data} = Ledger.new({:error, data})
    end
  end
end
