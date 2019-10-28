defmodule Kibitzing.Engine.Models.LevelTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Models.Level
  alias Kibitzing.Engine.Models.Level

  describe "all" do
    test "returns all possible levels" do
      assert Level.all() == [:one, :two, :three, :four, :five, :six, :seven]
    end
  end
end
