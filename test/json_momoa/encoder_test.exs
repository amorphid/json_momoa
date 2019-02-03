defmodule JSONMomoa.EncoderTest do
  use ExUnit.Case, async: true

  @subject JSONMomoa.Encoder

  describe "encoding true" do
    test "returns the expected string" do
      assert @subject.to_json(true) === "true"
    end
  end

  describe "encoding false" do
    test "returns the expected string" do
      assert @subject.to_json(false) === "false"
    end
  end

  describe "encoding null" do
    test "returns the expected string" do
      assert @subject.to_json(nil) === "null"
    end
  end
end
