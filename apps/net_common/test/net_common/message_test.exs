defmodule NetCommon.MessageTest do
  use ExUnit.Case
  doctest NetCommon.Message

  test "creates" do
    message = %NetCommon.Message{body: "hello", header: %NetCommon.Message.Header{id: 1}}

    assert message
  end

  test "size function" do
    message = %NetCommon.Message{body: "hello", header: %NetCommon.Message.Header{id: 1}}
    assert NetCommon.Message.size(message) == 140
  end

  test "put function" do
    message = %NetCommon.Message{header: %NetCommon.Message.Header{id: 1}}
    |> NetCommon.Message.put("hello")

    assert message.body == "hello"
    assert message.header.size == 140
    assert NetCommon.Message.size(message) == 140
  end
end
