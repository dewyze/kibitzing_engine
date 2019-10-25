defmodule Kibitzing.Engine.ConventionTest do
  use ExUnit.Case
  # doctest Kibitzing.Engine.Convention

  alias Kibitzing.Engine.Convention

  describe "new" do
    test "creates a convention" do
      convention = Convention.new(:two_over_one, "Two Over One", "2/1 Opening")

      assert match?(convention, %Convention{
               id: :two_over_one,
               name: "Two Over One",
               description: "2/1 Opening"
             })
    end
  end
end
