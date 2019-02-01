defmodule JSONMomoaTest do
  use ExUnit.Case, async: true

  @subject JSONMomoa

  setup do
    %{
      empty_array: "[]",
      empty_object: "{}",
      empty_string: "\"\"",
      false: "false",
      one: "1",
      negative_one: "-1",
      null: "null",
      true: "true",
      zero: "0"
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

  describe "parsing negative number" do
    test "returns negative number", c do
      assert @subject.parse(c.negative_one) == {-1, ""}
    end
  end

  describe "parsing non negative number" do
    test "returns non negative number", c do
      assert @subject.parse(c.zero) == {0, ""}
      assert @subject.parse(c.one) == {1, ""}
    end
  end

  describe "parsing null" do
    test "return nil", c do
      assert @subject.parse(c.null) == {nil, ""}
    end
  end

  describe "parsing true" do
    test "return true", c do
      assert @subject.parse(c.true) == {true, ""}
    end
  end
end
