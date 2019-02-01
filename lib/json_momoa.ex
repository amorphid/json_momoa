defmodule JSONMomoa do
  @moduledoc """
  Documentation for JSONMomoa.
  """

  #######
  # API #
  #######

  def parse("{" <> data) do
    in_object(data, %{})
  end

  def parse("\"" <> data) do
    in_string(data, "")
  end

  ###########
  # Private #
  ###########

  def in_object("}" <> data, acc) do
    {acc, data}
  end

  def in_string("\"" <> data, acc) do
    {acc, data}
  end
end
