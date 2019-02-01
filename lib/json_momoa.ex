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

  ###########
  # Private #
  ###########

  def in_array("]" <> data, acc) do
    {acc, data}
  end

  def in_object("}" <> data, acc) do
    {acc, data}
  end

  def in_string("\"" <> data, acc) do
    {acc, data}
  end
end
