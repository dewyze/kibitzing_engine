defmodule Kibitzing.Engine.Conventions.OpeningTest do
  use ExUnit.Case
  use ExUnitProperties
  # alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Conventions.Opening
  alias Kibitzing.Engine.Conventions.Opening
  alias Kibitzing.Engine.Convention
  alias Kibitzing.Engine.Models.Table

  describe "#two_over_one" do
    test "works" do
      conv = Opening.two_over_one()
      bids = [{:one, :hearts, :N}, {:pass, :E}, {:two, :clubs, :S}]
      table = %Table{next_bids: bids}
      assert match?(%Table{conventions: [:two_over_one]}, Convention.process(conv, table))
    end

    test "works with a pass" do
      conv = Opening.two_over_one()
      bids = [{:pass, :E}, {:one, :hearts, :S}, {:pass, :W}, {:two, :clubs, :N}]
      table = %Table{next_bids: bids}
      assert match?(%Table{conventions: [:two_over_one]}, Convention.process(conv, table))
    end

    test "does not work if one partner has passed" do
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
end
