defmodule Kibitzing.Engine.Convention.Requirement.BidTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Convention.Table
  alias Support.Generators, as: Gen

  describe "pass" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Bid.pass().(table) == Bid.pass(table)
      end
    end

    test "returns true if the bid is a pass" do
      check all(table <- Gen.bid_with_table(only_levels: [:pass], only_strains: [:pass])) do
        assert Bid.pass(table)
      end
    end

    test "returns false if the bid is not a pass" do
      check all(table <- Gen.bid_with_table(ignore_levels: [:pass], ignore_strains: [:pass])) do
        refute Bid.pass(table)
      end
    end
  end
end
