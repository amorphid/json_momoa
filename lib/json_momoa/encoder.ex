defprotocol JSONMomoa.Encoder do
  def to_json(data)
end

alias JSONMomoa.Encoder

defimpl Encoder, for: Atom do
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
