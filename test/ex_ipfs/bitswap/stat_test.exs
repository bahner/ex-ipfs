defmodule ExIPFS.BitswapStatTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.BitswapStat, as: Stat

  describe "new/1" do
    test "fails on missing data" do
      catch_error(%Stat{} = Stat.new())
    end

    test "returns a new stat with data" do
      data = %{
        "BlocksReceived" => 1,
        "BlocksSent" => 2,
        "DataReceived" => 3,
        "DataSent" => 4,
        "DupBlksReceived" => 5,
        "DupDataReceived" => 6,
        "MessagesReceived" => 7,
        "Peers" => [],
        "ProvideBufLen" => 8,
        "Wantlist" => []
      }

      assert %Stat{} = Stat.new(data)
      assert stat = Stat.new(data)
      assert stat.blocks_received == 1
      assert stat.blocks_sent == 2
      assert stat.data_received == 3
      assert stat.data_sent == 4
      assert stat.dup_blks_received == 5
      assert stat.dup_data_received == 6
      assert stat.messages_received == 7
      assert stat.peers == []
      assert stat.provide_buf_len == 8
      assert stat.wantlist == []
    end

    test "error data" do
      data = %{
        "Message" => "this is an error",
        "Code" => 0
      }

      assert {:error, data} = Stat.new({:error, data})
    end
  end
end
