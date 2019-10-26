defmodule Kibitzing.Engine.ConventionTest do
  use ExUnit.Case
  # doctest Kibitzing.Engine.Convention

  alias Kibitzing.Engine.Convention

  describe "new" do
    test "creates a convention" do
      convention = Convention.new(:two_over_one, "2/1", "2/1 Opening")

      assert convention.id == :two_over_one
      assert convention.name == "2/1"
      assert convention.description == "2/1 Opening"
    end
  end
end
