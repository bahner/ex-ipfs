defmodule MyspaceIPFS.DiagCmdTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias MyspaceIPFS.DiagCmd, as: DiagCmd

  @diag_cmd %{
    "Active" => true,
    "Args" => ["arg1", "arg2"],
    "Command" => "command",
    "EndTime" => "2019-01-01T00:00:00.000000000Z",
    "ID" => "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N",
    "Options" => ["option1", "option2"],
    "StartTime" => "2019-01-01T00:00:00.000000000Z"
  }

  test "fails on missing data" do
    catch_error(%DiagCmd{} = DiagCmd.new())
  end

  test "create diag cmd" do
    assert %DiagCmd{} = DiagCmd.new(@diag_cmd)
    dc = DiagCmd.new(@diag_cmd)
    assert dc.active == true
    assert dc.args == ["arg1", "arg2"]
    assert dc.command == "command"
    assert dc.end_time == "2019-01-01T00:00:00.000000000Z"
    assert dc.id == "QmYyQSo1c1Ym7orWxLYvCrM2EmxFTANf8wXmmE7DWjhx5N"
    assert dc.options == ["option1", "option2"]
    assert dc.start_time == "2019-01-01T00:00:00.000000000Z"
  end
end
