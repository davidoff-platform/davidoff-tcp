defmodule NetCommonTest do
  use ExUnit.Case
  doctest NetCommon

  test "greets the world" do
    assert NetCommon.hello() == :world
  end
end
