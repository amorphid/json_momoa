defprotocol JSONMomoa.Encoder do
  def to_json(data)
end

alias JSONMomoa.Encoder

defimpl Encoder, for: Atom do
  #######
  # API #
  #######

  def to_json(true) do
    "true"
  end

  def to_json(false) do
    "false"
  end

  def to_json(nil) do
    "null"
  end
end

defimpl Encoder, for: BitString do
  #######
  # API #
  #######

  def to_json(data) do
    in_string(data, [?\"])
  end

  ###########
  # Private #
  ###########

  defp in_string("", acc) do
    [?\" | acc]
    |> Enum.reverse()
    |> to_string()
  end

  defp in_string(<<head::utf8(), tail::bits()>>, acc) when head in 0x20..0x21 or head in 0x23..0x2e or head in 0x30..0x5B or head in 0x5D..0x10FFFF do
    in_string(tail, [head | acc])
  end

  defp in_string("\"" <> data, acc) do
    in_string(data, [?", ?\\ | acc ])
  end

  defp in_string("\\" <> data, acc) do
    in_string(data, [?\\, ?\\ | acc ])
  end

  defp in_string("\/" <> data, acc) do
    in_string(data, [?/, ?\\ | acc ])
  end

  defp in_string("\b" <> data, acc) do
    in_string(data, [?b, ?\\ | acc ])
  end

  defp in_string("\f" <> data, acc) do
    in_string(data, [?f, ?\\ | acc ])
  end

  defp in_string("\n" <> data, acc) do
    in_string(data, [?n, ?\\ | acc ])
  end

  defp in_string("\r" <> data, acc) do
    in_string(data, [?r, ?\\ | acc ])
  end

  defp in_string("\t" <> data, acc) do
    in_string(data, [?t, ?\\ | acc ])
  end

  defp in_string(<<head::utf8(), tail::bits()>>, acc) do
    case Integer.to_charlist(head, 16) do
      [num1] -> 
        in_string(tail, [num1, ?0, ?0, ?0, ?u, ?\\ | acc ])

      [num1, num2] -> 
        in_string(tail, [num2, num1, ?0, ?0, ?u, ?\\ | acc ])
    end
  end
end
