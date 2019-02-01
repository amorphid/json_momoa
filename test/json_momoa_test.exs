defmodule JSONMomoaTest do
  use ExUnit.Case, async: true

  @subject JSONMomoa

  setup do
    %{
      empty_object: "{}",
      empty_string: "\"\""
    }
  end

  describe "empty object" do
    test "return empty map", c do
      assert @subject.parse(c.empty_object) == {%{}, ""}
    end
  end

  describe "empty string" do
    test "return empty string", c do
      assert @subject.parse(c.empty_string) == {"", ""}
    end
  end
end
