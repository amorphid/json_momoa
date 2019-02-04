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

  describe "encoding the atom :abc" do
    test "returns the expected string" do
      assert @subject.to_json(:abc) === "\"abc\""
    end
  end

  describe "encoding the atom :Abc" do
    test "returns the expected string" do
      assert @subject.to_json(:Abc) === "\"Abc\""
    end
  end

  describe "encoding the atom for the module name Abc" do
    test "returns the expected string" do
      assert @subject.to_json(Abc) === "\"Elixir.Abc\""
    end
  end

  describe "encoding an empty string" do
    test "returns the expected string" do
      assert @subject.to_json("") === "\"\""
    end
  end

  describe "encoding the string \"abc\"" do
    test "returns the expected string" do
      assert @subject.to_json("abc") === "\"abc\""
    end
  end

  describe "encoding the \" character" do
    test "returns the expected string" do
      assert @subject.to_json("\"") === "\"\\\"\""
    end
  end

  describe "encoding the \\ character" do
    test "returns the expected string" do
      assert @subject.to_json("\\") === "\"\\\\\""
    end
  end

  describe "encoding the / character" do
    test "returns the expected string" do
      assert @subject.to_json("/") === "\"\\/\""
    end
  end

  describe "encoding the \b character" do
    test "returns the expected string" do
      assert @subject.to_json("\b") === "\"\\b\""
    end
  end

  describe "encoding the \f character" do
    test "returns the expected string" do
      assert @subject.to_json("\f") === "\"\\f\""
    end
  end

  describe "encoding the \n character" do
    test "returns the expected string" do
      assert @subject.to_json("\n") === "\"\\n\""
    end
  end

  describe "encoding the \r character" do
    test "returns the expected string" do
      assert @subject.to_json("\r") === "\"\\r\""
    end
  end

  describe "encoding the \t character" do
    test "returns the expected string" do
      assert @subject.to_json("\t") === "\"\\t\""
    end
  end

  describe "encoding various control characters" do
    test "returns the expected string" do
      assert @subject.to_json(<<0>>) === "\"\\u0000\""
      assert @subject.to_json(<<1>>) === "\"\\u0001\""
      assert @subject.to_json(<<2>>) === "\"\\u0002\""
      assert @subject.to_json(<<3>>) === "\"\\u0003\""
      assert @subject.to_json(<<4>>) === "\"\\u0004\""
      assert @subject.to_json(<<5>>) === "\"\\u0005\""
      assert @subject.to_json(<<6>>) === "\"\\u0006\""
      assert @subject.to_json(<<7>>) === "\"\\u0007\""
      assert @subject.to_json(<<11>>) === "\"\\u000B\""
      assert @subject.to_json(<<14>>) === "\"\\u000E\""
      assert @subject.to_json(<<15>>) === "\"\\u000F\""
      assert @subject.to_json(<<16>>) === "\"\\u0010\""
      assert @subject.to_json(<<17>>) === "\"\\u0011\""
      assert @subject.to_json(<<18>>) === "\"\\u0012\""
      assert @subject.to_json(<<19>>) === "\"\\u0013\""
      assert @subject.to_json(<<20>>) === "\"\\u0014\""
      assert @subject.to_json(<<21>>) === "\"\\u0015\""
      assert @subject.to_json(<<22>>) === "\"\\u0016\""
      assert @subject.to_json(<<23>>) === "\"\\u0017\""
      assert @subject.to_json(<<24>>) === "\"\\u0018\""
      assert @subject.to_json(<<25>>) === "\"\\u0019\""
      assert @subject.to_json(<<26>>) === "\"\\u001A\""
      assert @subject.to_json(<<27>>) === "\"\\u001B\""
      assert @subject.to_json(<<28>>) === "\"\\u001C\""
      assert @subject.to_json(<<29>>) === "\"\\u001D\""
      assert @subject.to_json(<<30>>) === "\"\\u001E\""
      assert @subject.to_json(<<31>>) === "\"\\u001F\""
    end
  end

  describe "encoding string \"hełło\"" do
    test "returns expected string" do
      assert @subject.to_json("hełło") === "\"hełło\""
    end
  end

  describe "encoding a positive integer" do
    test "returns expected string" do
      assert @subject.to_json(123) === "123"
    end
  end

  describe "encoding a negative integer" do
    test "returns expected string" do
      assert @subject.to_json(-123) === "-123"
    end
  end
end
