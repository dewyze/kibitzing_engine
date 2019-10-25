defmodule Kibitzing.Engine.Convention.Bid.LevelTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Bid.Level
  alias Kibitzing.Engine.Convention.Bid.Level
  alias Support.Generators, as: Gen

  describe "levels" do
    test "returns all possible levels" do
      assert Level.levels() == [:one, :two, :three, :four, :five, :six, :seven]
    end
  end

  describe "one" do
    test "returns a function that asserts if a bid is at the one level" do
      check all(bid <- Gen.bid(only_levels: [:one])) do
        assert Level.one().(bid)
      end
    end

    test "returns a function that refutes if a bid is not at the one level" do
      check all(bid <- Gen.bid(ignore_levels: [:one])) do
        refute Level.one().(bid)
      end
    end
  end

  describe "two" do
    test "returns a function that checks if a bid is at the two level" do
      check all(bid <- Gen.bid(only_levels: [:two])) do
        assert Level.two().(bid)
      end
    end

    test "returns a function that refutes if a bid is not at the two level" do
      check all(bid <- Gen.bid(ignore_levels: [:two])) do
        refute Level.two().(bid)
      end
    end
  end

  describe "three" do
    test "returns a function that checks if a bid is at the three level" do
      check all(bid <- Gen.bid(only_levels: [:three])) do
        assert Level.three().(bid)
      end
    end

    test "returns a function that refutes if a bid is not at the three level" do
      check all(bid <- Gen.bid(ignore_levels: [:three])) do
        refute Level.three().(bid)
      end
    end
  end

  describe "four" do
    test "returns a function that checks if a bid is at the four level" do
      check all(bid <- Gen.bid(only_levels: [:four])) do
        assert Level.four().(bid)
      end
    end

    test "returns a function that refutes if a bid is not at the four level" do
      check all(bid <- Gen.bid(ignore_levels: [:four])) do
        refute Level.four().(bid)
      end
    end
  end

  describe "five" do
    test "returns a function that checks if a bid is at the five level" do
      check all(bid <- Gen.bid(only_levels: [:five])) do
        assert Level.five().(bid)
      end
    end

    test "returns a function that refutes if a bid is not at the five level" do
      check all(bid <- Gen.bid(ignore_levels: [:five])) do
        refute Level.five().(bid)
      end
    end
  end

  describe "six" do
    test "returns a function that checks if a bid is at the six level" do
      check all(bid <- Gen.bid(only_levels: [:six])) do
        assert Level.six().(bid)
      end
    end

    test "returns a function that refutes if a bid is not at the six level" do
      check all(bid <- Gen.bid(ignore_levels: [:six])) do
        refute Level.six().(bid)
      end
    end
  end

  describe "seven" do
    test "returns a function that checks if a bid is at the seven level" do
      check all(bid <- Gen.bid(only_levels: [:seven])) do
        assert Level.seven().(bid)
      end
    end

    test "returns a function that refutes if a bid is not at the seven level" do
      check all(bid <- Gen.bid(ignore_levels: [:seven])) do
        refute Level.seven().(bid)
      end
    end
  end
end
