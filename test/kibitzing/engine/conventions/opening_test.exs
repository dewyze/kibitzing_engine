defmodule Kibitzing.Engine.Conventions.OpeningTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Conventions.Opening
  alias Kibitzing.Engine.Conventions.Opening
  alias Kibitzing.Engine.Convention
  alias Kibitzing.Engine.Models.Table

  describe "#two_over_one" do
    # TODO: Convert to generator tests
    test "adds the two_over_one convention" do
      conv = Opening.two_over_one()
      bids = [{:one, :hearts, :N}, {:pass, :E}, {:two, :clubs, :S}]
      table = %Table{next_bids: bids}
      assert match?(%Table{conventions: [:two_over_one]}, Convention.process(conv, table))
    end

    test "adds the two_over_one convention with a pass" do
      conv = Opening.two_over_one()
      bids = [{:pass, :E}, {:one, :hearts, :S}, {:pass, :W}, {:two, :clubs, :N}]
      table = %Table{next_bids: bids}
      assert match?(%Table{conventions: [:two_over_one]}, Convention.process(conv, table))
    end

    test "does not add the convention if one partner has passed" do
      conv = Opening.two_over_one()
      bids = [{:pass, :N}, {:pass, :E}, {:one, :hearts, :S}, {:pass, :W}, {:two, :clubs, :N}]
      table = %Table{next_bids: bids}
      assert match?(%Table{conventions: []}, Convention.process(conv, table))
    end

    test "does not work with anything" do
      conv = Opening.two_over_one()
      bids = [{2, :clubs, :N}]
      table = %Table{next_bids: bids}
      assert match?(%Table{conventions: []}, Convention.process(conv, table))
    end
  end

  describe "strong_two_clubs" do
    test "adds the convention for a strong two club opener" do
      check all(
              two_clubs <- Gen.contract_bid(only: [:two, :clubs]),
              passes <- list_of(Gen.pass(), max_length: 3)
            ) do
        table = %Table{next_bids: passes ++ [two_clubs]}
        conv = Opening.strong_two_clubs()
        assert match?(%Table{conventions: [:strong_two_clubs]}, Convention.process(conv, table))
      end
    end

    test "does not add convention if there are previous bids" do
      check all(
              prev_bids <- list_of(Gen.non_pass(), min_length: 1, max_length: 3),
              # TODO: Add shortcut for ignoring one bid
              Enum.all?(prev_bids, fn bid -> !match?({:two, :clubs, _}, bid) end),
              two_clubs <- Gen.contract_bid(only: [:two, :clubs])
            ) do
        table = %Table{next_bids: prev_bids ++ [two_clubs]}
        conv = Opening.strong_two_clubs()
        assert match?(%Table{conventions: []}, Convention.process(conv, table))
      end
    end
  end
end
