defmodule Kibitzing.Engine.Convention.Bid.LevelTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Bid.Level
  alias Kibitzing.Engine.Convention.Bid.Level
  alias Kibitzing.Engine.Convention.Table
  alias Support.Generators, as: Gen

  describe "levels" do
    test "returns all possible levels" do
      assert Level.levels() == [:one, :two, :three, :four, :five, :six, :seven]
    end
  end

  describe "one" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Level.one().(table) == Level.one(table)
      end
    end

    test "returns a function that asserts if a bid is at the one level" do
      check all(bid <- Gen.bid(only_levels: [:one])) do
        table = %Table{bid: bid}
        assert Level.one(table)
      end
    end

    test "returns a function that refutes if a bid is not at the one level" do
      check all(bid <- Gen.bid(ignore_levels: [:one])) do
        table = %Table{bid: bid}
        refute Level.one(table)
      end
    end
  end

  describe "two" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Level.two().(table) == Level.two(table)
      end
    end

    test "returns a function that checks if a bid is at the two level" do
      check all(bid <- Gen.bid(only_levels: [:two])) do
        table = %Table{bid: bid}
        assert Level.two(table)
      end
    end

    test "returns a function that refutes if a bid is not at the two level" do
      check all(bid <- Gen.bid(ignore_levels: [:two])) do
        table = %Table{bid: bid}
        refute Level.two(table)
      end
    end
  end

  describe "three" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Level.three().(table) == Level.three(table)
      end
    end

    test "returns a function that checks if a bid is at the three level" do
      check all(bid <- Gen.bid(only_levels: [:three])) do
        table = %Table{bid: bid}
        assert Level.three(table)
      end
    end

    test "returns a function that refutes if a bid is not at the three level" do
      check all(bid <- Gen.bid(ignore_levels: [:three])) do
        table = %Table{bid: bid}
        refute Level.three(table)
      end
    end
  end

  describe "four" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Level.four().(table) == Level.four(table)
      end
    end

    test "returns a function that checks if a bid is at the four level" do
      check all(bid <- Gen.bid(only_levels: [:four])) do
        table = %Table{bid: bid}
        assert Level.four(table)
      end
    end

    test "returns a function that refutes if a bid is not at the four level" do
      check all(bid <- Gen.bid(ignore_levels: [:four])) do
        table = %Table{bid: bid}
        refute Level.four(table)
      end
    end
  end

  describe "five" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Level.five().(table) == Level.five(table)
      end
    end

    test "returns a function that checks if a bid is at the five level" do
      check all(bid <- Gen.bid(only_levels: [:five])) do
        table = %Table{bid: bid}
        assert Level.five(table)
      end
    end

    test "returns a function that refutes if a bid is not at the five level" do
      check all(bid <- Gen.bid(ignore_levels: [:five])) do
        table = %Table{bid: bid}
        refute Level.five(table)
      end
    end
  end

  describe "six" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Level.six().(table) == Level.six(table)
      end
    end

    test "returns a function that checks if a bid is at the six level" do
      check all(bid <- Gen.bid(only_levels: [:six])) do
        table = %Table{bid: bid}
        assert Level.six(table)
      end
    end

    test "returns a function that refutes if a bid is not at the six level" do
      check all(bid <- Gen.bid(ignore_levels: [:six])) do
        table = %Table{bid: bid}
        refute Level.six(table)
      end
    end
  end

  describe "seven" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Level.seven().(table) == Level.seven(table)
      end
    end

    test "returns a function that checks if a bid is at the seven level" do
      check all(bid <- Gen.bid(only_levels: [:seven])) do
        table = %Table{bid: bid}
        assert Level.seven(table)
      end
    end

    test "returns a function that refutes if a bid is not at the seven level" do
      check all(bid <- Gen.bid(ignore_levels: [:seven])) do
        table = %Table{bid: bid}
        refute Level.seven(table)
      end
    end
  end
end
