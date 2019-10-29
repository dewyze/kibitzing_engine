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

  describe "lower_levels" do
    test "returns an empty list for one" do
      check all(bid <- Gen.contract_bid(only: [:one])) do
        assert Level.lower_levels(bid) == []
      end
    end

    test "returns higher levels for two" do
      check all(bid <- Gen.contract_bid(only: [:two])) do
        assert Level.lower_levels(bid) == [:one]
      end
    end

    test "returns higher levels for three" do
      check all(bid <- Gen.contract_bid(only: [:three])) do
        assert Level.lower_levels(bid) == [:one, :two]
      end
    end

    test "returns higher levels for four" do
      check all(bid <- Gen.contract_bid(only: [:four])) do
        assert Level.lower_levels(bid) == [:one, :two, :three]
      end
    end

    test "returns higher levels for five" do
      check all(bid <- Gen.contract_bid(only: [:five])) do
        assert Level.lower_levels(bid) == [:one, :two, :three, :four]
      end
    end

    test "returns higher levels for six" do
      check all(bid <- Gen.contract_bid(only: [:six])) do
        assert Level.lower_levels(bid) == [:one, :two, :three, :four, :five]
      end
    end

    test "returns higher levels for seven" do
      check all(bid <- Gen.contract_bid(only: [:seven])) do
        assert Level.lower_levels(bid) == [:one, :two, :three, :four, :five, :six]
      end
    end
  end

  describe "higher_levels" do
    test "returns higher levels for one" do
      check all(bid <- Gen.contract_bid(only: [:one])) do
        assert Level.higher_levels(bid) == [:two, :three, :four, :five, :six, :seven]
      end
    end

    test "returns higher levels for two" do
      check all(bid <- Gen.contract_bid(only: [:two])) do
        assert Level.higher_levels(bid) == [:three, :four, :five, :six, :seven]
      end
    end

    test "returns higher levels for three" do
      check all(bid <- Gen.contract_bid(only: [:three])) do
        assert Level.higher_levels(bid) == [:four, :five, :six, :seven]
      end
    end

    test "returns higher levels for four" do
      check all(bid <- Gen.contract_bid(only: [:four])) do
        assert Level.higher_levels(bid) == [:five, :six, :seven]
      end
    end

    test "returns higher levels for five" do
      check all(bid <- Gen.contract_bid(only: [:five])) do
        assert Level.higher_levels(bid) == [:six, :seven]
      end
    end

    test "returns higher levels for six" do
      check all(bid <- Gen.contract_bid(only: [:six])) do
        assert Level.higher_levels(bid) == [:seven]
      end
    end

    test "returns an empty list for seven" do
      check all(bid <- Gen.contract_bid(only: [:seven])) do
        assert Level.higher_levels(bid) == []
      end
    end
  end
end
