defmodule JSONMomoa do
  @moduledoc """
  Documentation for JSONMomoa.
  """

  #######
  # API #
  #######

  defdelegate parse(data), to: JSONMomoa.Parser
end
