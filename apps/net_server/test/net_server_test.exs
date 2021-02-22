defmodule NetServerTest do
  use ExUnit.Case
  doctest NetServer

  test "greets the world" do
    assert NetServer.hello() == :world
  end
end
