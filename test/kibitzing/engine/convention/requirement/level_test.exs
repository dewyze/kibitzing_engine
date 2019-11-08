defmodule Kibitzing.Engine.Convention.Requirement.LevelTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Requirement.Level
  alias Kibitzing.Engine.Convention.Requirement.Level
  alias Kibitzing.Engine.Models.Level, as: Model
  alias Support.Generators, as: Gen

  describe "one" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.one().(table) == Level.one(table)
      end
    end

    test "returns :ok if a bid is at the one level" do
      check all(table <- Gen.table(bid: Gen.one_bid())) do
        assert Level.one(table) == :ok
      end
    end

    test "returns next if the bid is an action bid" do
      check all(table <- Gen.table(bid: Gen.action_bid())) do
        assert Level.one(table) == :next
      end
    end

    test "returns false if a bid is not at the one level" do
      check all(table <- Gen.table(bid: Gen.contract_bid(ignore: [:one]))) do
        assert Level.one(table) == :fail
      end
    end
  end

  describe "two" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.two().(table) == Level.two(table)
      end
    end

    test "returns :ok if a bid is at the two level" do
      check all(table <- Gen.table(bid: Gen.two_bid())) do
        assert Level.two(table) == :ok
      end
    end

    test "returns :next if the bid is lower or a contract bid" do
      check all(
              bid <- Gen.two_bid(),
              levels = Model.lower_levels(bid),
              table <- Gen.table(bid: one_of([Gen.contract_bid(only: levels), Gen.action_bid()]))
            ) do
        assert Level.two(table) == :next
      end
    end

    test "returns :fail if the bid is higher" do
      check all(
              bid <- Gen.two_bid(),
              levels = Model.higher_levels(bid),
              table <- Gen.table(bid: Gen.contract_bid(only: levels))
            ) do
        assert Level.two(table) == :fail
      end
    end
  end

  describe "three" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.three().(table) == Level.three(table)
      end
    end

    test "returns :ok if a bid is at the three level" do
      check all(table <- Gen.table(bid: Gen.three_bid())) do
        assert Level.three(table) == :ok
      end
    end

    test "returns :next if the bid is lower or a contract bid" do
      check all(
              bid <- Gen.three_bid(),
              levels = Model.lower_levels(bid),
              table <- Gen.table(bid: one_of([Gen.contract_bid(only: levels), Gen.action_bid()]))
            ) do
        assert Level.three(table) == :next
      end
    end

    test "returns :fail if the bid is higher" do
      check all(
              bid <- Gen.three_bid(),
              levels = Model.higher_levels(bid),
              table <- Gen.table(bid: Gen.contract_bid(only: levels))
            ) do
        assert Level.three(table) == :fail
      end
    end
  end

  describe "four" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.four().(table) == Level.four(table)
      end
    end

    test "returns :ok if a bid is at the four level" do
      check all(table <- Gen.table(bid: Gen.four_bid())) do
        assert Level.four(table) == :ok
      end
    end

    test "returns :next if the bid is lower or a contract bid" do
      check all(
              bid <- Gen.four_bid(),
              levels = Model.lower_levels(bid),
              table <- Gen.table(bid: one_of([Gen.contract_bid(only: levels), Gen.action_bid()]))
            ) do
        assert Level.four(table) == :next
      end
    end

    test "returns :fail if the bid is higher" do
      check all(
              bid <- Gen.four_bid(),
              levels = Model.higher_levels(bid),
              table <- Gen.table(bid: Gen.contract_bid(only: levels))
            ) do
        assert Level.four(table) == :fail
      end
    end
  end

  describe "five" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.five().(table) == Level.five(table)
      end
    end

    test "returns :ok if a bid is at the five level" do
      check all(table <- Gen.table(bid: Gen.five_bid())) do
        assert Level.five(table) == :ok
      end
    end

    test "returns :next if the bid is lower or a contract bid" do
      check all(
              bid <- Gen.five_bid(),
              levels = Model.lower_levels(bid),
              table <- Gen.table(bid: one_of([Gen.contract_bid(only: levels), Gen.action_bid()]))
            ) do
        assert Level.five(table) == :next
      end
    end

    test "returns :fail if the bid is higher" do
      check all(
              bid <- Gen.five_bid(),
              levels = Model.higher_levels(bid),
              table <- Gen.table(bid: Gen.contract_bid(only: levels))
            ) do
        assert Level.five(table) == :fail
      end
    end
  end

  describe "six" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.six().(table) == Level.six(table)
      end
    end

    test "returns :ok if a bid is at the six level" do
      check all(table <- Gen.table(bid: Gen.six_bid())) do
        assert Level.six(table) == :ok
      end
    end

    test "returns :next if the bid is lower or a contract bid" do
      check all(
              bid <- Gen.six_bid(),
              levels = Model.lower_levels(bid),
              table <- Gen.table(bid: one_of([Gen.contract_bid(only: levels), Gen.action_bid()]))
            ) do
        assert Level.six(table) == :next
      end
    end

    test "returns :fail if the bid is higher" do
      check all(
              bid <- Gen.six_bid(),
              levels = Model.higher_levels(bid),
              table <- Gen.table(bid: Gen.contract_bid(only: levels))
            ) do
        assert Level.six(table) == :fail
      end
    end
  end

  describe "seven" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Level.seven().(table) == Level.seven(table)
      end
    end

    test "returns :ok if a bid is at the seven level" do
      check all(table <- Gen.table(bid: Gen.seven_bid())) do
        assert Level.seven(table) == :ok
      end
    end

    test "returns :next if the bid is lower or a contract bid" do
      check all(
              bid <- Gen.seven_bid(),
              levels = Model.lower_levels(bid),
              table <- Gen.table(bid: one_of([Gen.contract_bid(only: levels), Gen.action_bid()]))
            ) do
        assert Level.seven(table) == :next
      end
    end
  end
end
