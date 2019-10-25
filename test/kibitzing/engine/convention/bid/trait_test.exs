defmodule Kibitzing.Engine.Convention.Bid.TraitTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Convention.Bid.Trait
  alias Kibitzing.Engine.Convention.Bid.Trait
  alias Kibitzing.Engine.Convention.Table

  describe "opening_bid" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Trait.opening_bid().(table) == Trait.opening_bid(table)
      end
    end

    test "returns a function that returns true if it is the first bid" do
      check all(table <- Gen.bid_with_table()) do
        table = %{table | previous_bids: []}
        assert Trait.opening_bid(table)
      end
    end

    test "returns a function that returns true if it is the first non pass" do
      check all(
              passes <- list_of(Gen.pass()),
              table <- Gen.bid_with_table(previous_bids: passes)
            ) do
        assert Trait.opening_bid(table)
      end
    end

    test "returns a function that fails with a previous" do
      check all(
              bids <- list_of(Gen.bid(), min_length: 1),
              table <- Gen.bid_with_table(previous_bids: bids)
            ) do
        refute Trait.opening_bid(table)
      end
    end
  end
end
