defmodule NetClientTest do
  use ExUnit.Case
  doctest NetClient

  test "greets the world" do
    assert NetClient.hello() == :world
  end
end
