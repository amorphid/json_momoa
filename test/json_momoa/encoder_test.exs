defmodule JSONMomoa.EncoderTest do
  use ExUnit.Case, async: true

  @subject JSONMomoa.Encoder

  describe "encoding true" do
    test "returns the expected string" do
      assert @subject.to_json(true) === "true"
    end
  end
end
