defmodule Kibitzing.EngineTest do
  use ExUnit.Case
  doctest Kibitzing.Engine

  test "greets the world" do
    assert Kibitzing.Engine.hello() == :world
  end
end
