defmodule Kibitzing.Engine.Convention.Requirement.StrainTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Convention.Requirement.Strain
  alias Kibitzing.Engine.Models.Table
  alias Kibitzing.Engine.Models.Strain, as: Model
  alias Kibitzing.Engine.Convention.Requirement.Strain

  describe "no_trump" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.no_trump().(table) == Strain.no_trump(table)
      end
    end

    test "returns true if a bid is no trump" do
      check all(table <- Gen.table(bid: Gen.no_trump_bid())) do
        assert Strain.no_trump(table)
      end
    end

    test "returns false if a bid is not no trump" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:no_trump]))) do
        refute Strain.no_trump(table)
      end
    end
  end

  describe "spades" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.spades().(table) == Strain.spades(table)
      end
    end

    test "returns true if a bid is spades trump" do
      check all(table <- Gen.table(bid: Gen.spade_bid())) do
        assert Strain.spades(table)
      end
    end

    test "returns false if a bid is not spades" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:spades]))) do
        refute Strain.spades(table)
      end
    end
  end

  describe "hearts" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.hearts().(table) == Strain.hearts(table)
      end
    end

    test "returns true if a bid is hearts trump" do
      check all(table <- Gen.table(bid: Gen.heart_bid())) do
        assert Strain.hearts(table)
      end
    end

    test "returns false if a bid is not hearts" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:hearts]))) do
        refute Strain.hearts(table)
      end
    end
  end

  describe "diamonds" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.diamonds().(table) == Strain.diamonds(table)
      end
    end

    test "returns true if a bid is diamonds trump" do
      check all(table <- Gen.table(bid: Gen.diamond_bid())) do
        assert Strain.diamonds(table)
      end
    end

    test "returns false if a bid is not diamonds" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:diamonds]))) do
        refute Strain.diamonds(table)
      end
    end
  end

  describe "clubs" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.clubs().(table) == Strain.clubs(table)
      end
    end

    test "returns true if a bid is clubs trump" do
      check all(table <- Gen.table(bid: Gen.club_bid())) do
        assert Strain.clubs(table)
      end
    end

    test "returns false if a bid is not clubs" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: [:clubs]))) do
        refute Strain.clubs(table)
      end
    end
  end

  describe "major" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.major().(table) == Strain.major(table)
      end
    end

    test "returns true if a bid is a major" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: Model.majors()))) do
        assert Strain.major(table)
      end
    end

    test "returns false if a bid is not a major" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: Model.majors()))) do
        refute Strain.major(table)
      end
    end
  end

  describe "minor" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.minor().(table) == Strain.minor(table)
      end
    end

    test "returns true if a bid is a minor" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: Model.minors()))) do
        assert Strain.minor(table)
      end
    end

    test "returns false if a bid is not a minor" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: Model.minors()))) do
        refute Strain.minor(table)
      end
    end
  end

  describe "suit" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.suit().(table) == Strain.suit(table)
      end
    end

    test "returns true if a contract bid is a suit" do
      check all(
              table <-
                Gen.table(bid: Gen.suit_bid())
            ) do
        assert Strain.suit(table)
      end
    end

    test "returns false if a bid is not a suit" do
      check all(
              table <-
                Gen.table(bid: Gen.bid(only: [:double, :redouble, :pass, :no_trump]))
            ) do
        refute Strain.suit(table)
      end
    end
  end

  describe "new_strain" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table(bid: Gen.bid())) do
        assert Strain.new_strain().(table) == Strain.new_strain(table)
      end
    end

    test "returns true if a bid has an unmentioned strain" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              bids <- list_of(Gen.bid(ignore: [strain]))
            ) do
        table = %Table{previous_bids: bids, bid: bid}
        assert Strain.new_strain(table)
      end
    end

    test "returns false if a bid has a mentioned strain" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              bids <- list_of(Gen.bid())
            ) do
        table = %Table{previous_bids: bids ++ [{:five, strain, :N}], bid: bid}
        refute Strain.new_strain(table)
      end
    end
  end

  describe "equal_to" do
    test "returns the same as 'eq'" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Strain.eq(bid_func).(table) == Strain.equal_to(bid_func).(table)
      end
    end

    test "with 1 arg returns the same as with 2 args" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Strain.equal_to(bid_func).(table) == Strain.equal_to(bid_func, table)
      end
    end

    test "returns false if the current bid is an action bid" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.action_bid())) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.equal_to(bid_func, table)
      end
    end

    test "returns true if the current bid is the same strain as the other bid" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              table <- Gen.table(bid: Gen.contract_bid(only: [strain]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        assert Strain.equal_to(bid_func, table)
      end
    end

    test "returns false if the current bid is not the same strain as the other bid" do
      check all(
              {_, strain, _} = bid <- Gen.contract_bid(),
              table <- Gen.table(bid: Gen.contract_bid(ignore: [strain]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.equal_to(bid_func, table)
      end
    end
  end

  describe "lower_than" do
    test "returns the same as 'lt'" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Strain.lt(bid_func).(table) == Strain.lower_than(bid_func).(table)
      end
    end

    test "with 1 arg returns the same as with 2 args" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Strain.lower_than(bid_func).(table) == Strain.lower_than(bid_func, table)
      end
    end

    test "returns false if the previous bid is clubs" do
      check all(
              bid <- Gen.club_bid(),
              table <- Gen.table()
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.lower_than(bid_func, table)
      end
    end

    test "returns false if the current bid is an action bid" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.action_bid())
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.lower_than(bid_func, table)
      end
    end

    test "returns false if the current bid is no_trump" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.no_trump_bid())
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.lower_than(bid_func, table)
      end
    end

    test "returns true if a bid's strain is lower than a previous one" do
      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              table <- Gen.table(bid: Gen.contract_bid(only: Model.lower_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        assert Strain.lower_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is higher than a previous one" do
      check all(
              {_, strain, _} = lower_bid <- Gen.suit_bid(),
              table <- Gen.table(bid: Gen.contract_bid(only: Model.higher_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, lower_bid} end
        refute Strain.lower_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is equal to a previous one" do
      check all(
              {_, strain, _} = lower_bid <- Gen.suit_bid(),
              table <- Gen.table(bid: Gen.contract_bid(only: [strain]))
            ) do
        bid_func = fn _ -> {:ok, lower_bid} end
        refute Strain.lower_than(bid_func, table)
      end
    end
  end

  describe "higher_than" do
    test "returns the same as 'ht'" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Strain.ht(bid_func).(table) == Strain.higher_than(bid_func).(table)
      end
    end

    test "with 1 arg returns the same as with 2 args" do
      check all(bid <- Gen.bid(), table <- Gen.table(bid: Gen.bid())) do
        bid_func = fn _ -> {:ok, bid} end
        assert Strain.higher_than(bid_func).(table) == Strain.higher_than(bid_func, table)
      end
    end

    test "returns false if the previous bid is no_trump" do
      check all(
              bid <- Gen.no_trump_bid(),
              table <- Gen.table()
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.higher_than(bid_func, table)
      end
    end

    test "returns false if the current bid is an action bid" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.action_bid())
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.higher_than(bid_func, table)
      end
    end

    test "returns false if the current bid is clubs" do
      check all(
              bid <- Gen.bid(),
              table <- Gen.table(bid: Gen.club_bid())
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.higher_than(bid_func, table)
      end
    end

    test "returns true if a bid's strain is higher than a previous one" do
      check all(
              {_, strain, _} = lower_bid <- Gen.suit_bid(),
              table <- Gen.table(bid: Gen.contract_bid(only: Model.higher_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, lower_bid} end
        assert Strain.higher_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is lower than a previous one" do
      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              table <- Gen.table(bid: Gen.contract_bid(only: Model.lower_strains(strain)))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        refute Strain.higher_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is equal to a previous one" do
      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              table <- Gen.table(bid: Gen.contract_bid(only: [strain]))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        refute Strain.higher_than(bid_func, table)
      end
    end
  end
end
