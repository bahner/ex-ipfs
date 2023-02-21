defmodule ExIPFS.CommandsCommandTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.CommandsCommand, as: Command

  describe "new/1" do
    test "fails on missing data" do
      catch_error(%Command{} = Command.new())
    end

    test "create new Command" do
      data = %{
        "Name" => "name",
        "Options" => ["options"],
        "Subcommands" => [
          %{
            "Name" => "name",
            "Options" => [],
            "Subcommands" => []
          }
        ]
      }

      assert %Command{} = Command.new(data)
      command = Command.new(data)
      assert command.name == "name"
      assert command.options == ["options"]
      assert is_list(command.subcommands)

      assert command.subcommands == [
               %ExIPFS.CommandsCommand{name: "name", options: [], subcommands: []}
             ]
    end

    test "handle error data" do
      data = %{
        "Message" => "this is an error",
        "Code" => 0
      }

      assert {:error, data} = Command.new({:error, data})
    end
  end
end
