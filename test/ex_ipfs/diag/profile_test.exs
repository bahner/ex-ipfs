defmodule ExIPFS.DiagProfileTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias ExIPFS.DiagProfile, as: DiagProfile

  @profile %{
    "Ref" => "ref",
    "Output" => "output",
    "QueryOptions" => "query_options",
    "Writer" => "writer",
    "Timeout" => "30s"
  }

  test "fails on missing data" do
    catch_error(%DiagProfile{} = DiagProfile.new())
  end

  test "test creation of profile" do
    assert %DiagProfile{} = DiagProfile.new(@profile)
    p = DiagProfile.new(@profile)
    assert p.ref == "ref"
    assert p.output == "output"
    assert p.query_options == "query_options"
    assert p.writer == "writer"
    assert p.timeout == "30s"
  end
end
