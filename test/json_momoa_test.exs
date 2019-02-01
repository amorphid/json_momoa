defmodule JSONMomoaTest do
  use ExUnit.Case, async: true

  @subject JSONMomoa

  setup do
    %{
      empty_array: "[]",
      empty_object: "{}",
      empty_string: "\"\"",
      false: "false",
      true: "true"
    }
  end

  describe "parsing empty array" do
    test "return empty list", c do
      assert @subject.parse(c.empty_array) == {[], ""}
    end
  end

  describe "parsing empty object" do
    test "return empty map", c do
      assert @subject.parse(c.empty_object) == {%{}, ""}
    end
  end

  describe "parsing empty string" do
    test "return empty string", c do
      assert @subject.parse(c.empty_string) == {"", ""}
    end
  end

  describe "parsing false" do
    test "return false", c do
      assert @subject.parse(c.false) == {false, ""}
    end
  end

  describe "parsing true" do
    test "return true", c do
      assert @subject.parse(c.true) == {true, ""}
    end
  end
end
