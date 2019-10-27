defmodule Kibitzing.Engine.Convention.Requirement.BidTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Convention.Requirement.{Bid, UnreachableError}
  alias Kibitzing.Engine.Convention.Table
  alias Support.Generators, as: Gen

  describe "pass" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Bid.pass().(table) == Bid.pass(table)
      end
    end

    test "returns true if the bid is a pass" do
      check all(table <- Gen.table(bid: Gen.pass())) do
        assert Bid.pass(table)
      end
    end

    test "returns false if the bid is not a pass" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:pass], ignore: [:pass]))) do
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
      check all(table <- Gen.table(bid: Gen.double())) do
        assert Bid.double(table)
      end
    end

    test "returns false if the bid is not a double" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(ignore: [:double], ignore: [:double]))
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
                Gen.table(bid: Gen.redouble())
            ) do
        assert Bid.redouble(table)
      end
    end

    test "returns false if the bid is not a redouble" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(ignore: [:redouble], ignore: [:redouble]))
            ) do
        refute Bid.redouble(table)
      end
    end
  end

  describe "from_prev_partner" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table(prev: list_of(Gen.contract_bid(), min_length: 2))) do
        assert Bid.from_prev_partner().(table) == Bid.from_prev_partner(table)
      end
    end

    test "returns the previous partner bid if one exists" do
      check all(
              partner_bid <- Gen.bid(),
              opponent_bid <- Gen.bid(),
              bids <- list_of(Gen.bid()),
              bid <- Gen.contract_bid(),
              table = %Table{bid: bid, previous_bids: [opponent_bid, partner_bid] ++ bids}
            ) do
        assert Bid.from_prev_partner(table) == partner_bid
      end
    end

    test "raises an error if partner has not bid" do
      check all(table <- Gen.table(prev: list_of(Gen.contract_bid(), max_length: 1))) do
        assert_raise(UnreachableError, fn ->
          Bid.from_prev_partner(table)
        end)
      end
    end
  end
end
