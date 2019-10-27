defmodule Kibitzing.Engine.Convention.Requirement.TraitTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Convention.Requirement.Trait
  alias Kibitzing.Engine.Convention.Requirement.Trait

  describe "opening_bid" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Trait.opening_bid().(table) == Trait.opening_bid(table)
      end
    end

    test "returns true if it is the first bid" do
      check all(table <- Gen.table()) do
        table = %{table | previous_bids: []}
        assert Trait.opening_bid(table)
      end
    end

    test "returns true if it is the first non pass" do
      check all(
              table <-
                Gen.table(
                  bid: Gen.contract_bid(),
                  prev: list_of(Gen.pass())
                )
            ) do
        assert Trait.opening_bid(table)
      end
    end

    test "returns false with a previous bid" do
      check all(
              table <-
                Gen.table(
                  bid: Gen.bid(),
                  prev: list_of(Gen.contract_bid(), min_length: 1)
                )
            ) do
        refute Trait.opening_bid(table)
      end
    end
  end
end
