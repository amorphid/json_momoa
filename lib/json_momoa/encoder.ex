defprotocol JSONMomoa.Encoder do
  @type data() :: any()
  @type encoded :: String.t()

  @spec to_json(data()) :: encoded()
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

  def to_json(data) do
    data
    |> to_string()
    |> JSONMomoa.Encoder.BitString.to_json()
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

  defp in_string(<<head::utf8(), tail::bits()>>, acc)
       when head in 0x20..0x21 or head in 0x23..0x2E or head in 0x30..0x5B or
              head in 0x5D..0x10FFFF do
    in_string(tail, [head | acc])
  end

  defp in_string("\"" <> data, acc) do
    in_string(data, [?", ?\\ | acc])
  end

  defp in_string("\\" <> data, acc) do
    in_string(data, [?\\, ?\\ | acc])
  end

  defp in_string("\/" <> data, acc) do
    in_string(data, [?/, ?\\ | acc])
  end

  defp in_string("\b" <> data, acc) do
    in_string(data, [?b, ?\\ | acc])
  end

  defp in_string("\f" <> data, acc) do
    in_string(data, [?f, ?\\ | acc])
  end

  defp in_string("\n" <> data, acc) do
    in_string(data, [?n, ?\\ | acc])
  end

  defp in_string("\r" <> data, acc) do
    in_string(data, [?r, ?\\ | acc])
  end

  defp in_string("\t" <> data, acc) do
    in_string(data, [?t, ?\\ | acc])
  end

  defp in_string(<<head::utf8(), tail::bits()>>, acc) do
    case Integer.to_charlist(head, 16) do
      [num1] ->
        in_string(tail, [num1, ?0, ?0, ?0, ?u, ?\\ | acc])

      [num1, num2] ->
        in_string(tail, [num2, num1, ?0, ?0, ?u, ?\\ | acc])
    end
  end
end

defimpl JSONMomoa.Encoder, for: Integer do
  #######
  # API #
  #######

  def to_json(data) do
    Integer.to_string(data, 10)
  end
end

defimpl JSONMomoa.Encoder, for: Float do
  def to_json(data) do
    Float.to_string(data)
  end
end

defimpl JSONMomoa.Encoder, for: List do
  #######
  # API #
  #######

  def to_json([]) do
    "[]"
  end

  def to_json(data) do
    in_list(data, "[")
  end

  ###########
  # Private #
  ###########

  defp in_list([head | []], acc) do
    acc <> JSONMomoa.to_json(head) <> "]"
  end

  defp in_list([head | tail], acc) do
    in_list(tail, acc <> JSONMomoa.to_json(head) <> ",")
  end
end

defimpl JSONMomoa.Encoder, for: Map do
  #######
  # API #
  #######

  def to_json(data) do
    if map_size(data) == 0 do
      "{}"
    else
      data
      |> Enum.to_list()
      |> in_list("{")
    end
  end

  ###########
  # Private #
  ###########

  defp in_list([{key, value} | []], acc) when is_binary(key) or is_atom(key) do
    acc <> JSONMomoa.to_json(key) <> ":" <> JSONMomoa.to_json(value) <> "}"
  end

  defp in_list([{key, value} | tail], acc)
       when is_binary(key) or is_atom(key) do
    in_list(
      tail,
      acc <> JSONMomoa.to_json(key) <> ":" <> JSONMomoa.to_json(value) <> ","
    )
  end
end

# The following is a hack to suppress dialyzer errors/warnings:
# - error messages appear for unimplemented types when running 'mix dialyzer'
# - for each type, error message looks like...
#   _____________________________________________________________________________
#   :0:unknown_function
#   Function JSONMomoa.Encoder.SomeType.__impl__/1 does not exist.
# - this hack should (probably) be defined after all implementations
:ok =
  (fn protocol_module ->
     [
       Atom,
       BitString,
       Float,
       Function,
       Integer,
       List,
       Map,
       PID,
       Port,
       Reference,
       Tuple
     ]
     |> Enum.each(fn type ->
       try do
         _ = Module.concat(protocol_module, type).module_info
       rescue
         _ ->
           defimpl protocol_module, for: type do
             def to_json(_) do
               raise "encoding not implement for type #{unquote(type)}"
             end
           end
       end
     end)
   end).(Encoder)
