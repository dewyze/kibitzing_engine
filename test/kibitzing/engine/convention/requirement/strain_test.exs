defmodule Kibitzing.Engine.Convention.Requirement.StrainTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Convention.Requirement.Strain
  alias Kibitzing.Engine.Models.{Strain, Table}
  alias Kibitzing.Engine.Convention.Requirement.Strain, as: Req

  describe "no_trump" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.no_trump().(table) == Req.no_trump(table)
      end
    end

    test "returns true if a bid is no trump" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:no_trump]))) do
        assert Req.no_trump(table)
      end
    end

    test "returns false if a bid is not no trump" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:no_trump]))) do
        refute Req.no_trump(table)
      end
    end
  end

  describe "spades" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.spades().(table) == Req.spades(table)
      end
    end

    test "returns true if a bid is spades trump" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:spades]))) do
        assert Req.spades(table)
      end
    end

    test "returns false if a bid is not spades" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:spades]))) do
        refute Req.spades(table)
      end
    end
  end

  describe "hearts" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.hearts().(table) == Req.hearts(table)
      end
    end

    test "returns true if a bid is hearts trump" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:hearts]))) do
        assert Req.hearts(table)
      end
    end

    test "returns false if a bid is not hearts" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:hearts]))) do
        refute Req.hearts(table)
      end
    end
  end

  describe "diamonds" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.diamonds().(table) == Req.diamonds(table)
      end
    end

    test "returns true if a bid is diamonds trump" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:diamonds]))) do
        assert Req.diamonds(table)
      end
    end

    test "returns false if a bid is not diamonds" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:diamonds]))) do
        refute Req.diamonds(table)
      end
    end
  end

  describe "clubs" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.clubs().(table) == Req.clubs(table)
      end
    end

    test "returns true if a bid is clubs trump" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:clubs]))) do
        assert Req.clubs(table)
      end
    end

    test "returns false if a bid is not clubs" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:clubs]))) do
        refute Req.clubs(table)
      end
    end
  end

  describe "major" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.major().(table) == Req.major(table)
      end
    end

    test "returns true if a bid is a major" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: Strain.majors()))) do
        assert Req.major(table)
      end
    end

    test "returns false if a bid is not a major" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: Strain.majors()))) do
        refute Req.major(table)
      end
    end
  end

  describe "minor" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.minor().(table) == Req.minor(table)
      end
    end

    test "returns true if a bid is a minor" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: Strain.minors()))) do
        assert Req.minor(table)
      end
    end

    test "returns false if a bid is not a minor" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: Strain.minors()))) do
        refute Req.minor(table)
      end
    end
  end

  describe "suit" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Req.suit().(table) == Req.suit(table)
      end
    end

    test "returns true if a contract bid is a suit" do
      check all(
              table <-
                Gen.table(bid: Gen.contract_bid(ignore: [:no_trump]))
            ) do
        assert Req.suit(table)
      end
    end

    test "returns false if a bid is not a suit" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(only: [:double, :redouble, :pass, :no_trump]))
            ) do
        refute Req.suit(table)
      end
    end
  end

  describe "new_strain" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table(bid: Gen.bid())) do
        assert Req.new_strain().(table) == Req.new_strain(table)
      end
    end

    test "returns true if a bid has an unmentioned strain" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              bids <- list_of(Gen.bid(ignore: [strain]))
            ) do
        table = %Table{previous_bids: bids, bid: bid}
        assert Req.new_strain(table)
      end
    end

    test "returns false if a bid has a mentioned strain" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              bids <- list_of(Gen.bid())
            ) do
        table = %Table{previous_bids: bids ++ [{:five, strain, :N}], bid: bid}
        refute Req.new_strain(table)
      end
    end
  end

  describe "equal_to" do
    test "returns the same as 'eq'" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Req.eq(bid_func).(table) == Req.equal_to(bid_func).(table)
      end
    end

    test "with 1 arg returns the same as with 2 args" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Req.equal_to(bid_func).(table) == Req.equal_to(bid_func, table)
      end
    end

    test "returns false if the current bid is an action bid" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.action_bid())) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.equal_to(bid_func, table)
      end
    end

    test "returns true if the current bid is the same strain as the other bid" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              table <- Gen.table(bid: Gen.contract_bid(only: [strain]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        assert Req.equal_to(bid_func, table)
      end
    end

    test "returns false if the current bid is not the same strain as the other bid" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              table <- Gen.table(bid: Gen.contract_bid(ignore: [strain]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.equal_to(bid_func, table)
      end
    end
  end

  describe "lower_than" do
    test "returns the same as 'lt'" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Req.lt(bid_func).(table) == Req.lower_than(bid_func).(table)
      end
    end

    test "with 1 arg returns the same as with 2 args" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Req.lower_than(bid_func).(table) == Req.lower_than(bid_func, table)
      end
    end

    test "returns false if the previous bid is clubs" do
      check all(
              bid <- Gen.contract_bid(only: [:clubs]),
              table <- Gen.table()
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.lower_than(bid_func, table)
      end
    end

    test "returns false if the current bid is an action bid" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.action_bid())
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.lower_than(bid_func, table)
      end
    end

    test "returns false if the current bid is no_trump" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.bid(only: [:no_trump]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.lower_than(bid_func, table)
      end
    end

    test "returns true if a bid's strain is lower than a previous one" do
      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              table <- Gen.table(bid: Gen.contract_bid(only: Strain.lower_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        assert Req.lower_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is higher than a previous one" do
      check all(
              {_, strain, _} = lower_bid <- Gen.contract_bid(ignore: [:no_trump]),
              table <- Gen.table(bid: Gen.contract_bid(only: Strain.higher_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, lower_bid} end
        refute Req.lower_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is equal to a previous one" do
      check all(
              {_, strain, _} = lower_bid <- Gen.contract_bid(ignore: [:no_trump]),
              table <- Gen.table(bid: Gen.contract_bid(only: [strain]))
            ) do
        bid_func = fn _ -> {:ok, lower_bid} end
        refute Req.lower_than(bid_func, table)
      end
    end
  end

  describe "higher_than" do
    test "returns the same as 'ht'" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Req.ht(bid_func).(table) == Req.higher_than(bid_func).(table)
      end
    end

    test "with 1 arg returns the same as with 2 args" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Req.higher_than(bid_func).(table) == Req.higher_than(bid_func, table)
      end
    end

    test "returns false if the previous bid is no_trump" do
      check all(
              bid <- Gen.contract_bid(only: [:no_trump]),
              table <- Gen.table()
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.higher_than(bid_func, table)
      end
    end

    test "returns false if the current bid is an action bid" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.action_bid())
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.higher_than(bid_func, table)
      end
    end

    test "returns false if the current bid is clubs" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.bid(only: [:clubs]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Req.higher_than(bid_func, table)
      end
    end

    test "returns true if a bid's strain is higher than a previous one" do
      check all(
              {_, strain, _} = lower_bid <- Gen.contract_bid(ignore: [:no_trump]),
              table <- Gen.table(bid: Gen.contract_bid(only: Strain.higher_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, lower_bid} end
        assert Req.higher_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is lower than a previous one" do
      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              table <- Gen.table(bid: Gen.contract_bid(only: Strain.lower_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        refute Req.higher_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is equal to a previous one" do
      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              table <- Gen.table(bid: Gen.contract_bid(only: [strain]))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        refute Req.higher_than(bid_func, table)
      end
    end
  end
end
