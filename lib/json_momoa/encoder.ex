defprotocol JSONMomoa.Encoder do
  def to_json(data)
end

alias JSONMomoa.Encoder

defimpl Encoder, for: Atom do
  def to_json(true) do
    "true"
  end
end
