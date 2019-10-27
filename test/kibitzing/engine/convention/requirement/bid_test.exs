defmodule Kibitzing.Engine.Convention.Requirement.BidTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Convention.Requirement.Bid
  alias Support.Generators, as: Gen

  describe "pass" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Bid.pass().(table) == Bid.pass(table)
      end
    end

    test "returns true if the bid is a pass" do
      check all(table <- Gen.table(bid: Gen.bid(only_levels: [:pass], only_strains: [:pass]))) do
        assert Bid.pass(table)
      end
    end

    test "returns false if the bid is not a pass" do
      check all(table <- Gen.table(bid: Gen.bid(ignore_levels: [:pass], ignore_strains: [:pass]))) do
        refute Bid.pass(table)
      end
    end
  end

  describe "double" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Bid.double().(table) == Bid.double(table)
      end
    end

    test "returns true if the bid is a double" do
      check all(table <- Gen.table(bid: Gen.bid(only_levels: [:double], only_strains: [:double]))) do
        assert Bid.double(table)
      end
    end

    test "returns false if the bid is not a double" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(ignore_levels: [:double], ignore_strains: [:double]))
            ) do
        refute Bid.double(table)
      end
    end
  end

  describe "redouble" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Bid.redouble().(table) == Bid.redouble(table)
      end
    end

    test "returns true if the bid is a redouble" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(only_levels: [:redouble], only_strains: [:redouble]))
            ) do
        assert Bid.redouble(table)
      end
    end

    test "returns false if the bid is not a redouble" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(ignore_levels: [:redouble], ignore_strains: [:redouble]))
            ) do
        refute Bid.redouble(table)
      end
    end
  end
end
