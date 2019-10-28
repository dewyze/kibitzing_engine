defmodule Kibitzing.Engine.Convention.Requirement.StrainTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Convention.Requirement.Strain
  alias Kibitzing.Engine.Convention.Requirement.Strain
  alias Kibitzing.Engine.Convention.Table

  describe "strains" do
    test "returns all possible strains" do
      assert Strain.strains() == [:clubs, :diamonds, :hearts, :spades, :no_trump]
    end
  end

  describe "majors" do
    test "returns all possible strains" do
      assert Strain.majors() == [:hearts, :spades]
    end
  end

  describe "minors" do
    test "returns all possible strains" do
      assert Strain.minors() == [:clubs, :diamonds]
    end
  end

  describe "lower_strains" do
    test "returns lower strains for no_trump" do
      check all(bid <- Gen.contract_bid(only: [:no_trump])) do
        assert Strain.lower_strains(bid) == [:clubs, :diamonds, :hearts, :spades]
      end
    end

    test "returns lower strains for spades" do
      check all(bid <- Gen.contract_bid(only: [:spades])) do
        assert Strain.lower_strains(bid) == [:clubs, :diamonds, :hearts]
      end
    end

    test "returns lower strains for hearts" do
      check all(bid <- Gen.contract_bid(only: [:hearts])) do
        assert Strain.lower_strains(bid) == [:clubs, :diamonds]
      end
    end

    test "returns lower strains for diamonds" do
      check all(bid <- Gen.contract_bid(only: [:diamonds])) do
        assert Strain.lower_strains(bid) == [:clubs]
      end
    end

    test "returns an empty list for clubs" do
      check all(bid <- Gen.contract_bid(only: [:clubs])) do
        assert Strain.lower_strains(bid) == []
      end
    end
  end

  describe "higher_strains" do
    test "returns an empty list for no_trump" do
      check all(bid <- Gen.contract_bid(only: [:no_trump])) do
        assert Strain.higher_strains(bid) == []
      end
    end

    test "returns higher strains for spades" do
      check all(bid <- Gen.contract_bid(only: [:spades])) do
        assert Strain.higher_strains(bid) == [:no_trump]
      end
    end

    test "returns higher strains for hearts" do
      check all(bid <- Gen.contract_bid(only: [:hearts])) do
        assert Strain.higher_strains(bid) == [:spades, :no_trump]
      end
    end

    test "returns higher strains for diamonds" do
      check all(bid <- Gen.contract_bid(only: [:diamonds])) do
        assert Strain.higher_strains(bid) == [:hearts, :spades, :no_trump]
      end
    end

    test "returns an empty list for clubs" do
      check all(bid <- Gen.contract_bid(only: [:clubs])) do
        assert Strain.higher_strains(bid) == [:diamonds, :hearts, :spades, :no_trump]
      end
    end
  end

  describe "no_trump" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Strain.no_trump().(table) == Strain.no_trump(table)
      end
    end

    test "returns true if a bid is no trump" do
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:no_trump]))) do
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
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:spades]))) do
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
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:hearts]))) do
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
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:diamonds]))) do
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
      check all(table <- Gen.table(bid: Gen.contract_bid(only: [:clubs]))) do
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
      check all(table <- Gen.table(bid: Gen.contract_bid(only: Strain.majors()))) do
        assert Strain.major(table)
      end
    end

    test "returns false if a bid is not a major" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: Strain.majors()))) do
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
      check all(table <- Gen.table(bid: Gen.contract_bid(only: Strain.minors()))) do
        assert Strain.minor(table)
      end
    end

    test "returns false if a bid is not a minor" do
      check all(table <- Gen.table(bid: Gen.bid(ignore: Strain.minors()))) do
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
                Gen.table(bid: Gen.contract_bid(ignore: [:no_trump]))
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
              bid <- Gen.contract_bid(only: [:clubs]),
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
              table <- Gen.table(bid: Gen.bid(only: [:no_trump]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.lower_than(bid_func, table)
      end
    end

    test "returns true if a bid's strain is lower than a previous one" do
      strains = Strain.strains()

      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              lower_strains = Enum.take_while(strains, fn s -> s != strain end),
              table <- Gen.table(bid: Gen.contract_bid(only: lower_strains))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        assert Strain.lower_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is higher than or equal to a previous one" do
      strains = Enum.reverse(Strain.strains())

      check all(
              {_, strain, _} = lower_bid <- Gen.contract_bid(ignore: [:no_trump]),
              hte_strains = Enum.take_while(strains, fn s -> s != strain end),
              table <- Gen.table(bid: Gen.contract_bid(only: hte_strains))
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
              bid <- Gen.contract_bid(only: [:no_trump]),
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
              table <- Gen.table(bid: Gen.bid(only: [:clubs]))
            ) do
        bid_func = fn _ -> {:ok, bid} end
        refute Strain.higher_than(bid_func, table)
      end
    end

    test "returns true if a bid's strain is higher than a previous one" do
      strains = Enum.reverse(Strain.strains())

      check all(
              {_, strain, _} = lower_bid <- Gen.contract_bid(ignore: [:no_trump]),
              higher_strains = Enum.take_while(strains, fn s -> s != strain end),
              table <- Gen.table(bid: Gen.contract_bid(only: higher_strains))
            ) do
        bid_func = fn _ -> {:ok, lower_bid} end
        assert Strain.higher_than(bid_func, table)
      end
    end

    test "returns false if a bid's strain is lower than or equal to a previous one" do
      strains = Strain.strains()

      check all(
              {_, strain, _} = higher_bid <- Gen.contract_bid(ignore: [:clubs]),
              lte_strains = Enum.take_while(strains, fn s -> s != strain end),
              table <- Gen.table(bid: Gen.contract_bid(only: lte_strains))
            ) do
        bid_func = fn _ -> {:ok, higher_bid} end
        refute Strain.higher_than(bid_func, table)
      end
    end
  end
end
