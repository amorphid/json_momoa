defmodule JSONMomoa do
  @moduledoc """
  Parses JSON binary streams & encodes data as JSON.
  """

  #######
  # API #
  #######

  @doc """
  Parses leading JSON element in a JSON binary stream.

  Example:

      iex> {element0, data0} = JSONMomoa.parse("truefalse{}\\\"aw yiss\\\"")
      {true, "false{}\\\"aw yiss\\\""}
      iex>  {element1, data1} = JSONMomoa.parse("false{}\\\"aw yiss\\\"")
      {false, "{}\\\"aw yiss\\\""}
      iex>  {element2, data2} = JSONMomoa.parse("{}\\\"aw yiss\\\"")
      {%{}, "\\\"aw yiss\\\""}
      iex>  {element3, data3} = JSONMomoa.parse("\\\"aw yiss\\\"")
      {"aw yiss", ""}
  """
  defdelegate parse(data), to: JSONMomoa.Parser

  @doc """
  Encodes data as JSON.

  Example:

      iex> JSONMomoa.to_json([%{hello: "world"}, 1, 2, nil])
      "[{\\\"hello\\\":\\\"world\\\"},1,2,null]"
  """
  defdelegate to_json(data), to: JSONMomoa.Encoder
end
