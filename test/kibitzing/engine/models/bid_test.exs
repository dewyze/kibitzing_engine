defmodule Kibitzing.Engine.Models.BidTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Models.Bid
  alias Kibitzing.Engine.Models.Bid

  describe "#pass?" do
    test "returns true for a pass" do
      check all(pass <- Gen.pass()) do
        assert Bid.pass?(pass)
      end
    end

    test "returns false for any non-pass" do
      check all(bid <- one_of([Gen.double(), Gen.redouble(), Gen.contract_bid()])) do
        refute Bid.pass?(bid)
      end
    end
  end

  describe "#double?" do
    test "returns true for a double" do
      check all(double <- Gen.double()) do
        assert Bid.double?(double)
      end
    end

    test "returns false for any non-double" do
      check all(bid <- one_of([Gen.pass(), Gen.redouble(), Gen.contract_bid()])) do
        refute Bid.double?(bid)
      end
    end
  end

  describe "#redouble?" do
    test "returns true for a redouble" do
      check all(redouble <- Gen.redouble()) do
        assert Bid.redouble?(redouble)
      end
    end

    test "returns false for any non-redouble" do
      check all(bid <- one_of([Gen.double(), Gen.pass(), Gen.contract_bid()])) do
        refute Bid.redouble?(bid)
      end
    end
  end

  describe "#action?" do
    test "returns true for an action" do
      check all(action <- one_of([Gen.pass(), Gen.double(), Gen.redouble()])) do
        assert Bid.action?(action)
      end
    end

    test "returns false for any non-action" do
      check all(bid <- Gen.contract_bid()) do
        refute Bid.action?(bid)
      end
    end
  end

  describe "#higher" do
    test "returns true if the bid is higher" do
      check all(
              bid <- Gen.contract_bid(),
              !match?({:seven, :no_trump, _}, bid),
              higher_bid <- Gen.higher_bid(bid)
            ) do
        assert Bid.higher?(higher_bid, bid)
      end
    end

    test "returns false if the bid is lower or equal to" do
      check all(
              bid <- Gen.contract_bid(),
              !match?({:one, :clubs, _}, bid),
              lower_bid <- Gen.lower_bid(bid),
              bid_2 <- member_of([bid, lower_bid])
            ) do
        refute Bid.higher?(bid_2, bid)
      end
    end
  end

  describe "#lower" do
    test "returns true if the bid is lower" do
      check all(
              bid <- Gen.contract_bid(),
              !match?({:one, :clubs, _}, bid),
              lower_bid <- Gen.lower_bid(bid)
            ) do
        assert Bid.lower?(lower_bid, bid)
      end
    end

    test "returns false if the bid is lower or equal to" do
      check all(
              bid <- Gen.contract_bid(),
              !match?({:seven, :no_trump, _}, bid),
              higher_bid <- Gen.higher_bid(bid),
              bid_2 <- member_of([bid, higher_bid])
            ) do
        refute Bid.lower?(bid_2, bid)
      end
    end
  end
end
