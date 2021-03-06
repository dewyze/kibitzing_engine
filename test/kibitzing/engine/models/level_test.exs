defmodule Kibitzing.Engine.Models.LevelTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Models.Level
  alias Kibitzing.Engine.Models.Level

  describe "all" do
    test "returns all possible levels" do
      assert Level.all() == [:one, :two, :three, :four, :five, :six, :seven]
    end
  end

  describe "higher?" do
    test "returns true if the first level is higher than the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:one]),
              bid_2 <- Gen.contract_bid(only: Level.lower_levels(level))
            ) do
        assert Level.higher?(bid_1, bid_2)
      end
    end

    test "returns false if the first bid is lower than or equal to the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:seven]),
              levels = Level.higher_levels(level) ++ [level],
              bid_2 <- Gen.contract_bid(only: levels)
            ) do
        refute Level.higher?(bid_1, bid_2)
      end
    end
  end

  describe "lower?" do
    test "returns true if the first level is lower than the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:seven]),
              bid_2 <- Gen.contract_bid(only: Level.higher_levels(level))
            ) do
        assert Level.lower?(bid_1, bid_2)
      end
    end

    test "returns false if the first level is higher than or equal to the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:one]),
              levels = Level.lower_levels(level) ++ [level],
              bid_2 <- Gen.contract_bid(only: levels)
            ) do
        refute Level.lower?(bid_1, bid_2)
      end
    end
  end

  describe "lte?" do
    test "returns true if the first level is lower than or equal to the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:seven]),
              bid_2 <- Gen.contract_bid(only: Level.higher_levels(level) ++ [level])
            ) do
        assert Level.lte?(bid_1, bid_2)
      end
    end

    test "returns false if the first level is higher than the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:one]),
              levels = Level.lower_levels(level),
              bid_2 <- Gen.contract_bid(only: levels)
            ) do
        refute Level.lte?(bid_1, bid_2)
      end
    end
  end

  describe "hte?" do
    test "returns true if the first level is higher than or equal to the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:one]),
              bid_2 <- Gen.contract_bid(only: Level.lower_levels(level) ++ [level])
            ) do
        assert Level.hte?(bid_1, bid_2)
      end
    end

    test "returns false if the first level is lower than the second" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(ignore: [:seven]),
              levels = Level.higher_levels(level),
              bid_2 <- Gen.contract_bid(only: levels)
            ) do
        refute Level.hte?(bid_1, bid_2)
      end
    end
  end

  describe "lower_levels" do
    test "returns an empty list for one" do
      check all(bid <- Gen.one_bid()) do
        assert Level.lower_levels(bid) == []
      end
    end

    test "returns higher levels for two" do
      check all(bid <- Gen.two_bid()) do
        assert Level.lower_levels(bid) == [:one]
      end
    end

    test "returns higher levels for three" do
      check all(bid <- Gen.three_bid()) do
        assert Level.lower_levels(bid) == [:one, :two]
      end
    end

    test "returns higher levels for four" do
      check all(bid <- Gen.four_bid()) do
        assert Level.lower_levels(bid) == [:one, :two, :three]
      end
    end

    test "returns higher levels for five" do
      check all(bid <- Gen.five_bid()) do
        assert Level.lower_levels(bid) == [:one, :two, :three, :four]
      end
    end

    test "returns higher levels for six" do
      check all(bid <- Gen.six_bid()) do
        assert Level.lower_levels(bid) == [:one, :two, :three, :four, :five]
      end
    end

    test "returns higher levels for seven" do
      check all(bid <- Gen.seven_bid()) do
        assert Level.lower_levels(bid) == [:one, :two, :three, :four, :five, :six]
      end
    end
  end

  describe "higher_levels" do
    test "returns higher levels for one" do
      check all(bid <- Gen.one_bid()) do
        assert Level.higher_levels(bid) == [:two, :three, :four, :five, :six, :seven]
      end
    end

    test "returns higher levels for two" do
      check all(bid <- Gen.two_bid()) do
        assert Level.higher_levels(bid) == [:three, :four, :five, :six, :seven]
      end
    end

    test "returns higher levels for three" do
      check all(bid <- Gen.three_bid()) do
        assert Level.higher_levels(bid) == [:four, :five, :six, :seven]
      end
    end

    test "returns higher levels for four" do
      check all(bid <- Gen.four_bid()) do
        assert Level.higher_levels(bid) == [:five, :six, :seven]
      end
    end

    test "returns higher levels for five" do
      check all(bid <- Gen.five_bid()) do
        assert Level.higher_levels(bid) == [:six, :seven]
      end
    end

    test "returns higher levels for six" do
      check all(bid <- Gen.six_bid()) do
        assert Level.higher_levels(bid) == [:seven]
      end
    end

    test "returns an empty list for seven" do
      check all(bid <- Gen.seven_bid()) do
        assert Level.higher_levels(bid) == []
      end
    end
  end

  describe "#equal?" do
    test "returns true when levels are equal" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(),
              bid_2 <- Gen.contract_bid(only: [level])
            ) do
        assert Level.equal?(bid_1, bid_2)
      end
    end

    test "returns false when levels are not equal" do
      check all(
              {level, _, _} = bid_1 <- Gen.contract_bid(),
              bid_2 <- Gen.contract_bid(ignore: [level])
            ) do
        refute Level.equal?(bid_1, bid_2)
      end
    end
  end
end
