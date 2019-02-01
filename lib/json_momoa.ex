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

  ###########
  # Private #
  ###########

  def in_string("\"" <> data, acc) do
    {acc, data}
  end
end
