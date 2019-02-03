defmodule JSONMomoa do
  @moduledoc """
  Documentation for JSONMomoa.
  """

  #######
  # API #
  #######

  defdelegate parse(data), to: JSONMomoa.Parser

  defdelegate to_json(data), to: JSONMomoa.Encoder
end
