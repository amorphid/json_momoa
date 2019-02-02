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

  def parse(<<head::(8), _::bits()>> = data) when head in ?0..?9 or head == ?- do
    in_number(data)
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

  defp in_digits(<<head::(8), tail::bits()>>, acc) when head in ?0..?9 do
    in_digits(tail, [head | acc])
  end

  defp in_digits(data, acc) do
    parse_integer_or_float(data, acc, [])
  end

  defp in_frac(<<head::(8), tail::bits()>>, acc) when head in ?0..?9 do
    in_frac(tail, [head | acc])
  end

  defp in_frac(data, acc) do
    in_maybe_exp(data, acc)
  end

  defp in_integer(<<head::(8), tail::bits()>>, acc) when head in ?0..?9 do
    in_integer(tail, [head | acc])
  end

  defp in_integer(data, acc) do
    in_maybe_frac(data, acc)
  end

  defp in_maybe_exp(<<head::(8), tail::bits()>>, acc) when head == ?E or head == ?e do
    in_maybe_sign(tail, [?e | acc])
  end

  defp in_maybe_exp(data, acc) do
    in_digits(data, acc)
  end

  defp in_maybe_frac("." <> data, acc) do
    in_frac(data, [?. | acc])
  end

  defp in_maybe_frac(data, acc) do
    in_maybe_exp(data, acc)
  end

  defp in_maybe_negative_number("-" <> data, acc) do
    in_zero_or_onenine(data, [?- | acc])
  end

  defp in_maybe_negative_number(data, acc) do
    in_zero_or_onenine(data, acc)
  end

  defp in_maybe_sign(<<head::(8), tail::bits()>>, acc) when head == ?+ or head == ?- do
    in_digits(tail, [head | acc])
  end

  defp in_maybe_sign(data, acc)do
    in_digits(data, acc)
  end

  defp in_number(data) do
    in_maybe_negative_number(data, [])
  end

  defp in_object("}" <> data, acc) do
    {acc, data}
  end

  defp in_string("\"" <> data, acc) do
    {acc, data}
  end

  defp in_zero_or_onenine("0" <> data, acc) do
    in_maybe_frac(data, [?0 | acc])
  end

  defp in_zero_or_onenine(<<head::(8), tail::bits()>>, acc) when head in ?1..?9 do
    in_integer(tail, [head | acc])
  end

  defp parse_integer_or_float(data, [head | tail], acc) when head == ?e or head ==?. do
    {num, ""} = 
      [Enum.reverse(tail), head, acc]
      |> IO.iodata_to_binary()
      |> Float.parse()
    {num, data}
  end

  defp parse_integer_or_float(data, [head | tail], acc) do
    parse_integer_or_float(data, tail, [head | acc])
  end

  defp parse_integer_or_float(data, [], acc) do
    {num, ""} = Integer.parse(IO.iodata_to_binary(acc))
    {num, data}
  end
end
