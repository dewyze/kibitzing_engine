defmodule Kibitzing.Engine.Conventions.OpeningTest do
  use ExUnit.Case
  use ExUnitProperties
  # alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Conventions.Opening
  alias Kibitzing.Engine.Conventions.Opening
  alias Kibitzing.Engine.Convention
  alias Kibitzing.Engine.Models.Table

  describe "#two_over_one" do
    test "works" do
      conv = Opening.two_over_one()
      bids = [{:one, :hearts, :N}, {:pass, :E}, {:two, :clubs, :S}]
      table = %Table{next_bids: bids}
      assert match?(%Table{conventions: [:two_over_one]}, Convention.process(conv, table))
    end
  end
end
