defmodule Kibitzing.Engine.Convention.Requirement.TraitTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Convention.Requirement.Trait
  alias Kibitzing.Engine.Models.{Level, Strain, Table}
  alias Kibitzing.Engine.Convention.Requirement.Trait

  describe "first_bid" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Trait.first_bid().(table) == Trait.first_bid(table)
      end
    end

    test "returns :okay if it's a players first bid" do
      check all(table <- Gen.table(prev: list_of(Gen.bid(), max_length: 3))) do
        assert Trait.first_bid(table) == :ok
      end
    end

    test "returns :fail if player has already bid" do
      check all(table <- Gen.table(prev: list_of(Gen.bid(), min_length: 4))) do
        assert Trait.first_bid(table) == :fail
      end
    end
  end

  describe "opening_bid" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Trait.opening_bid().(table) == Trait.opening_bid(table)
      end
    end

    test "returns :ok if it is the first bid" do
      check all(
              table <-
                Gen.table(
                  bid: Gen.contract_bid(),
                  prev: constant([])
                )
            ) do
        assert Trait.opening_bid(table) == :ok
      end
    end

    test "returns :ok if it is the first non pass" do
      check all(
              table <-
                Gen.table(
                  bid: Gen.contract_bid(),
                  prev: list_of(Gen.pass())
                )
            ) do
        assert Trait.opening_bid(table) == :ok
      end
    end

    test "returns :next if the current bid is a pass and there are no previous bids" do
      check all(
              table <-
                Gen.table(
                  bid: Gen.pass(),
                  prev: list_of(Gen.pass())
                )
            ) do
        assert Trait.opening_bid(table) == :next
      end
    end

    test "returns :fail with a previous bid" do
      check all(
              table <-
                Gen.table(
                  bid: Gen.bid(),
                  prev: list_of(Gen.contract_bid(), min_length: 1)
                )
            ) do
        assert Trait.opening_bid(table) == :fail
      end
    end
  end

  describe "jump_shift" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.table()) do
        assert Trait.jump_shift().(table) == Trait.jump_shift(table)
      end
    end

    test "returns :next if there was no previous contract bid" do
      check all(
              table <-
                Gen.table(
                  bid: Gen.contract_bid(),
                  prev: list_of(one_of([constant([]), Gen.action_bid()]))
                )
            ) do
        assert Trait.jump_shift(table) == :next
      end
    end

    test "returns :next if current bid is an action bid" do
      check all(table <- Gen.table(bid: Gen.action_bid())) do
        assert Trait.jump_shift(table) == :next
      end
    end

    test "returns :next if it is a higher strain but not higher level" do
      check all(
              {level, strain, _} = prev_bid <- Gen.suit_bid(ignore: [:spades, :seven]),
              lte_levels = Level.lower_levels(level) ++ [level],
              higher_strains = Strain.higher_strains(strain),
              non_jump_shift <- Gen.contract_bid(only: lte_levels ++ higher_strains),
              table = %Table{bid: non_jump_shift, previous_bids: [prev_bid]}
            ) do
        assert Trait.jump_shift(table) == :next
      end
    end

    test "returns :next if it is a higher level but not higher strain" do
      check all(
              {level, strain, _} = prev_bid <- Gen.suit_bid(ignore: [:spades, :seven]),
              higher_levels = Level.higher_levels(level),
              lte_strains = Strain.lower_strains(strain) ++ [strain],
              non_jump_shift <- Gen.contract_bid(only: higher_levels ++ lte_strains),
              table = %Table{bid: non_jump_shift, previous_bids: [prev_bid]}
            ) do
        assert Trait.jump_shift(table) == :next
      end
    end

    test "returns :next if the previous bid is no trump, spade, or seven" do
      check all(
              table <-
                Gen.table(
                  prev: list_of(one_of([Gen.no_trump_bid(), Gen.spade_bid(), Gen.seven_bid()]))
                )
            ) do
        assert Trait.jump_shift(table) == :next
      end
    end

    test "returns :next if current bid is no trump, clubs, or a one" do
      check all(
              table <-
                Gen.table(bid: one_of([Gen.no_trump_bid(), Gen.one_bid(), Gen.club_bid()]))
            ) do
        assert Trait.jump_shift(table) == :next
      end
    end

    test "returns :ok if it is a jump shift from previous contract bid" do
      check all(
              {level, strain, _} = prev_bid <-
                Gen.contract_bid(ignore: [:no_trump, :spades, :seven]),
              higher_bids =
                (Level.higher_levels(level) ++ Strain.higher_strains(strain)) -- [:no_trump],
              jump_shift <- Gen.contract_bid(only: higher_bids),
              table = %Table{bid: jump_shift, previous_bids: [prev_bid]}
            ) do
        assert Trait.jump_shift(table) == :ok
      end
    end

    test "returns :ok if it is a jump shift with action bids" do
      check all(
              {level, strain, _} = prev_bid <-
                Gen.contract_bid(ignore: [:no_trump, :spades, :seven]),
              actions = list_of(Gen.action_bid()),
              higher_bids =
                (Level.higher_levels(level) ++ Strain.higher_strains(strain)) -- [:no_trump],
              jump_shift <- Gen.contract_bid(only: higher_bids),
              table = %Table{bid: jump_shift, previous_bids: [prev_bid] ++ actions}
            ) do
        assert Trait.jump_shift(table) == :ok
      end
    end
  end
end
