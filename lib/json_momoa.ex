defmodule JSONMomoa do
  @moduledoc """
  Documentation for JSONMomoa.
  """

  #######
  # API #
  #######

  def parse("\"" <> data) do
    in_string(data, "")
  end

  def parse(<<head::(8), _::bits()>> = data) when head in ?0..?9 do
    in_non_negative_number(data)
  end

  def parse("{" <> data) do
    in_object(data, %{})
  end

  def parse("[" <> data) do
    in_array(data, [])
  end

  def parse("true" <> data) do
    {true, data}
  end

  def parse("false" <> data) do
    {false, data}
  end

  def parse("null" <> data) do
    {nil, data}
  end

  ###########
  # Private #
  ###########

  defp in_array("]" <> data, acc) do
    {acc, data}
  end

  defp in_non_negative_number(data) do
    Integer.parse(data)
  end

  defp in_object("}" <> data, acc) do
    {acc, data}
  end

  defp in_string("\"" <> data, acc) do
    {acc, data}
  end
end
