defmodule Kibitzing.Engine.Convention.Requirement.LevelTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Requirement.Level
  alias Kibitzing.Engine.Convention.Requirement.Level
  alias Support.Generators, as: Gen

  describe "levels" do
    test "returns all possible levels" do
      assert Level.levels() == [:one, :two, :three, :four, :five, :six, :seven]
    end
  end

  describe "one" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.one().(table) == Level.one(table)
      end
    end

    test "returns trues if a bid is at the one level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:one]))) do
        assert Level.one(table)
      end
    end

    test "returns false if a bid is not at the one level" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:one]))) do
        refute Level.one(table)
      end
    end
  end

  describe "two" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.two().(table) == Level.two(table)
      end
    end

    test "returns true if a bid is at the two level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:two]))) do
        assert Level.two(table)
      end
    end

    test "returns false if a bid is not at the two level" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:two]))) do
        refute Level.two(table)
      end
    end
  end

  describe "three" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.three().(table) == Level.three(table)
      end
    end

    test "returns true if a bid is at the three level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:three]))) do
        assert Level.three(table)
      end
    end

    test "returns false if a bid is not at the three level" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:three]))) do
        refute Level.three(table)
      end
    end
  end

  describe "four" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.four().(table) == Level.four(table)
      end
    end

    test "returns true if a bid is at the four level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:four]))) do
        assert Level.four(table)
      end
    end

    test "returns false if a bid is not at the four level" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:four]))) do
        refute Level.four(table)
      end
    end
  end

  describe "five" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.five().(table) == Level.five(table)
      end
    end

    test "returns true if a bid is at the five level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:five]))) do
        assert Level.five(table)
      end
    end

    test "returns false if a bid is not at the five level" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:five]))) do
        refute Level.five(table)
      end
    end
  end

  describe "six" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.six().(table) == Level.six(table)
      end
    end

    test "returns true if a bid is at the six level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:six]))) do
        assert Level.six(table)
      end
    end

    test "returns false if a bid is not at the six level" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:six]))) do
        refute Level.six(table)
      end
    end
  end

  describe "seven" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.seven().(table) == Level.seven(table)
      end
    end

    test "returns true if a bid is at the seven level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:seven]))) do
        assert Level.seven(table)
      end
    end

    test "returns false if a bid is not at the seven level" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:seven]))) do
        refute Level.seven(table)
      end
    end
  end
end
