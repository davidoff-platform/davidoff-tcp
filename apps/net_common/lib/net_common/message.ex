defmodule NetCommon.Message do
  @enforce_keys [:header]
  defstruct [:header, body: ""]

  def size(message) do
    message |> :erlang.term_to_binary() |> :erlang.byte_size()
  end

  def put(message, body) do
    message = message |> Map.put(:body, body)
    Map.put(message, :header, Map.put(message.header, :size, message |> NetCommon.Message.size))
  end

  def create(id, body) do
    %NetCommon.Message{header: %NetCommon.Message.Header{id: id}}
    |> NetCommon.Message.put(body)
  end


  def types(:validation) do
    1000
  end
end
