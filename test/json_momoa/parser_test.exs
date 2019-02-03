defmodule JSONMomoa.ParserTest do
  use ExUnit.Case, async: true

  @subject JSONMomoa.Parser

  describe "parsing an element with leading whitespace" do
    test "trims the leading whitespace" do
      assert @subject.parse("\n\r\t    true") === {true, ""}
    end
  end

  describe "parsing an element with trailing whitespace" do
    test "does not trim trailing whitespace" do
      assert @subject.parse("true    \n\r\t") === {true, "    \n\r\t"}
    end
  end

  describe "parsing empty array" do
    test "return empty list" do
      assert @subject.parse("[]") === {[], ""}
    end
  end

  describe "parsing empty object" do
    test "return empty map" do
      assert @subject.parse("{}") === {%{}, ""}
    end
  end

  describe "parsing empty string" do
    test "return empty string" do
      assert @subject.parse("\"\"") === {"", ""}
    end
  end

  describe "parsing string \"abc\"" do
    test "returns expected string" do
      assert @subject.parse("\"abc\"") === {"abc", ""}
    end
  end

  describe "parsing string \"\\u0061\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\u0061\"") === {"a", ""}
    end
  end

  describe "parsing string \"\\t\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\t\"") === {"\t", ""}
    end
  end

  describe "parsing string \"\\r\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\r\"") === {"\r", ""}
    end
  end

  describe "parsing string \"\\n\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\n\"") === {"\n", ""}
    end
  end

  describe "parsing string \"\\f\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\f\"") === {"\f", ""}
    end
  end

  describe "parsing string \"\\b\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\b\"") === {"\b", ""}
    end
  end

  describe "parsing string \"\\/\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\/\"") === {"/", ""}
    end
  end

  describe "parsing string \"\\\\\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\\\\"") === {"\\", ""}
    end
  end

  describe "parsing string \"\\\"\"" do
    test "returns expected string" do
      assert @subject.parse("\"\\\"\"") === {"\"", ""}
    end
  end

  describe "parsing string \"hełło\"" do
    test "returns expected string" do
      assert @subject.parse("\"hełło\"") === {"hełło", ""}
    end
  end

  describe "parsing false" do
    test "return false" do
      assert @subject.parse("false") === {false, ""}
    end
  end

  describe "parsing the float 0.0" do
    test "returns 0.0" do
      assert @subject.parse("0.0") === {0.0, ""}
    end
  end

  describe "parsing the float 0.5" do
    test "returns 0.5" do
      assert @subject.parse("0.5") === {0.5, ""}
    end
  end

  describe "parsing the float 0.55" do
    test "returns 0.55" do
      assert @subject.parse("0.55") === {0.55, ""}
    end
  end

  describe "parsing the float -1234.5678" do
    test "returns -1234.5678" do
      assert @subject.parse("-1234.5678") === {-1234.5678, ""}
    end
  end

  describe "parsing the float 1234.5678" do
    test "returns 1234.5678" do
      assert @subject.parse("1234.5678") === {1234.5678, ""}
    end
  end

  describe "parsing the float 123.456e78" do
    test "returns 1.23456e80" do
      assert @subject.parse("1.23456e80") === {1.23456e80, ""}
    end
  end

  describe "parsing the float 123.456e+78" do
    test "returns 1.23456e80" do
      assert @subject.parse("123.456e+78") === {1.23456e80, ""}
    end
  end

  describe "parsing the float 123.456e-78" do
    test "returns 1.23456e80" do
      assert @subject.parse("123.456e-78") === {1.23456e-76, ""}
    end
  end

  describe "parsing the interger -1" do
    test "returns -1" do
      assert @subject.parse("-1") === {-1, ""}
    end
  end

  describe "parsing the interger 0" do
    test "returns 0" do
      assert @subject.parse("0") === {0, ""}
    end
  end

  describe "parsing the interger 1" do
    test "returns 1" do
      assert @subject.parse("1") === {1, ""}
    end
  end

  describe "parsing the integer 55" do
    test "returns 55" do
      assert @subject.parse("55") === {55, ""}
    end
  end

  describe "parsing the integer -1234567890" do
    test "returns -1234567890" do
      assert @subject.parse("-1234567890") === {-1234567890, ""}
    end
  end

  describe "parsing null" do
    test "return nil" do
      assert @subject.parse("null") === {nil, ""}
    end
  end

  describe "parsing true" do
    test "return true" do
      assert @subject.parse("true") === {true, ""}
    end
  end

  describe "parsing an object with 1 key value pair" do
    test "returns the expected map" do
      assert @subject.parse("{\"key\":\"value\"}") === {%{"key" => "value"}, ""}
    end
  end

  describe "parsing an object with 2 key value pairs" do
    test "returns the expected map" do
      assert @subject.parse("{\"key0\":\"value0\",\"key1\":true}") === {%{"key0" => "value0", "key1" => true}, ""}
    end
  end

  describe "parsing an array with 1 element" do
    test "returns the expected list" do
      assert @subject.parse("[\"element\"]") === {["element"], ""}
    end
  end

  describe "parsing an array with 2 elements" do
    test "returns the expected list" do
      assert @subject.parse("[\"element0\",\"element1\"]") === {["element0", "element1"], ""}
    end
  end
end
