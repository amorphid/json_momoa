defmodule JSONMomoaTest do
  use ExUnit.Case, async: true

  @subject JSONMomoa

  setup do
    %{
      empty_string: "\"\""
    }
  end

  describe "empty string" do
    test "return empty string", c do
      assert @subject.parse(c.empty_string) == {"", ""}
    end
  end
end
