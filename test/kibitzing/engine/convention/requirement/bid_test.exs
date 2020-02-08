defmodule Kibitzing.Engine.Convention.Requirement.BidTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Models.Table
  alias Support.Generators, as: Gen

  describe "exact_bid" do
    test "with no args returns the same as with args" do
      check all(
              {level, strain, _} <- Gen.contract_bid(),
              table <- Gen.table()
            ) do
        assert Bid.exact({level, strain}).(table) == Bid.exact({level, strain}, table)
      end
    end

    test "returns :ok for a match" do
      check all(
              {level, strain, _} <- Gen.contract_bid(),
              table <- Gen.table(bid: Gen.contract_bid(only: [level, strain]))
            ) do
        assert Bid.exact({level, strain}, table) == :ok
      end
    end

    test "returns :fail for a non match" do
      check all(
              {level, strain, _} <- Gen.contract_bid(),
              {bid_level, bid_strain, _} = bid <- Gen.contract_bid(),
              level != bid_level && strain != bid_strain,
              table <- Gen.table(bid: constant(bid))
            ) do
        assert Bid.exact({level, strain}, table) == :fail
      end
    end
  end

  describe "pass" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Bid.pass().(table) == Bid.pass(table)
      end
    end

    test "returns true if the bid is a pass" do
      check all(table <- Gen.table(bid: Gen.pass())) do
        assert Bid.pass(table) == :ok
      end
    end

    test "returns false if the bid is not a pass" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:pass]))) do
        assert Bid.pass(table) == :next
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
        assert Bid.double(table) == :ok
      end
    end

    test "returns false if the bid is not a double" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(ignore: [:double], ignore: [:double]))
            ) do
        assert Bid.double(table) == :next
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
        assert Bid.redouble(table) == :ok
      end
    end

    test "returns false if the bid is not a redouble" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(ignore: [:redouble], ignore: [:redouble]))
            ) do
        assert Bid.redouble(table) == :next
      end
    end
  end

  describe "first_bid" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Bid.first_bid().(table) == Bid.first_bid(table)
      end
    end

    test "returns :okay if it's a players first bid" do
      check all(table <- Gen.table(prev: list_of(Gen.bid(), max_length: 3))) do
        assert Bid.first_bid(table) == :ok
      end
    end

    test "returns :fail if player has already bid" do
      check all(table <- Gen.table(prev: list_of(Gen.bid(), min_length: 4))) do
        assert Bid.first_bid(table) == :fail
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
        assert Bid.from_prev_partner(table) == {:ok, partner_bid}
      end
    end

    test "raises an error if partner has not bid" do
      check all(table <- Gen.table(prev: list_of(Gen.contract_bid(), max_length: 1))) do
        assert Bid.from_prev_partner(table) == {:error, :no_previous_bid}
      end
    end
  end
end
