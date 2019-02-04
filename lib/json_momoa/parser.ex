defmodule JSONMomoa.Parser do
  @moduledoc """
  Documentation for JSONMomoa.
  """

  #######
  # API #
  #######

  def parse(<<head::8, tail::bits()>>) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> parse()
  end

  def parse("\"" <> data) do
    in_string(data, [])
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

  defp in_array(<<head::8, tail::bits()>>, acc) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> in_array(acc)
  end

  defp in_array("]" <> data, acc) do
    {Enum.reverse(acc), data}
  end

  defp in_array(data, acc) do
    in_element(data, acc)
  end

  defp in_digits(<<head::(8), tail::bits()>>, acc) when head in ?0..?9 do
    in_digits(tail, [head | acc])
  end

  defp in_digits(data, acc) do
    parse_integer_or_float(data, acc, [])
  end

  defp in_element(<<head::8, tail::bits()>>, acc) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> in_element(acc)
  end

  defp in_element(data, acc) do
    {element, data2} = parse(data)
    in_element_or_array(data2, [element | acc])
  end

  defp in_element_or_array(<<head::8, tail::bits()>>, acc) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> in_element_or_array(acc)
  end

  defp in_element_or_array("," <> data, acc) do
    in_element(data, acc)
  end

  defp in_element_or_array(data, acc) do
    in_array(data, acc)
  end

  def in_escaped("\"" <> data, acc) do
    in_string(data, [?\" | acc])
  end

  def in_escaped("\\" <> data, acc) do
    in_string(data, [?\\ | acc])
  end

  def in_escaped("/" <> data, acc) do
    in_string(data, [?/ | acc])
  end

  def in_escaped("b" <> data, acc) do
    in_string(data, [?\b | acc])
  end

  def in_escaped("f" <> data, acc) do
    in_string(data, [?\f | acc])
  end

  def in_escaped("n" <> data, acc) do
    in_string(data, [?\n | acc])
  end

  def in_escaped("r" <> data, acc) do
    in_string(data, [?\r | acc])
  end

  def in_escaped("t" <> data, acc) do
    in_string(data, [?\t | acc])
  end

  def in_escaped(<<?u::(8), hex0::(8), hex1::(8), hex2::(8), hex3::(8), tail::bits()>>, acc) do
    {char, ""} = 
      [hex0, hex1, hex2, hex3] 
      |> to_string()
      |> Integer.parse(16)
    in_string(tail, [char | acc])
  end

  defp in_frac(<<head::(8), tail::bits()>>, acc) when head in ?0..?9 do
    in_frac(tail, [head | acc])
  end

  defp in_frac(data, acc) do
    in_maybe_exp(data, acc)
  end

  defp in_key(<<head::8, tail::bits()>>, acc) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> in_key(acc)
  end

  defp in_key("\"" <> _ = data, acc) do
    {key, data2} = parse(data)
    in_value(data2, key, acc)
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

  defp in_key_or_object(<<head::8, tail::bits()>>, acc) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> in_key_or_object(acc)
  end

  defp in_key_or_object("," <> data, acc) do
    in_key(data, acc)
  end

  defp in_key_or_object(data, acc) do
    in_object(data, acc)
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

  defp in_object(<<head::8, tail::bits()>>, acc) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> in_object(acc)
  end

  defp in_object("}" <> data, acc) do
    {acc, data}
  end

  defp in_object(data, acc) do
    in_key(data, acc)
  end

  defp in_value(<<head::8, tail::bits()>>, key, acc) when head in [?\t, ?\n, ?\r, ?\s] do
    tail
    |> String.trim_leading()
    |> in_value(key, acc)
  end

  defp in_value(":" <> data, key, acc) do
    in_value(data, key, acc)
  end

  defp in_value(data, key, acc) do
    {value, data2} = parse(data)
    in_key_or_object(data2, Map.put(acc, key, value))
  end

  defp in_string("\"" <> data, acc) do
    str = 
      acc
      |> Enum.reverse()
      |> to_string()
    {str, data}
  end

  defp in_string("\\" <> data, acc) do
    in_escaped(data, acc)
  end

  defp in_string(<<head::utf8(), tail::bits()>>, acc) do
    in_string(tail, [head | acc])
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
      |> to_string()
      |> Float.parse()
    {num, data}
  end

  defp parse_integer_or_float(data, [head | tail], acc) do
    parse_integer_or_float(data, tail, [head | acc])
  end

  defp parse_integer_or_float(data, [], acc) do
    {num, ""} = Integer.parse(to_string(acc))
    {num, data}
  end
end
