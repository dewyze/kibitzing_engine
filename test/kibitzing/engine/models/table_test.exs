defmodule Kibitzing.Engine.Models.TableTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Models.Table
  alias Kibitzing.Engine.Models.Table

  describe "#validate" do
    test "returns true if each bid is increasing" do
      check all(
              bid <- Gen.contract_bid(),
              !match?({:seven, :no_trump, _}, bid),
              next <- Gen.higher_bid(bid),
              table = %Table{bid: nil, next_bids: [bid, next]}
            ) do
        assert match?({:ok, ^table}, Table.validate(table))
      end
    end

    test "returns false if each bid is not increasing" do
      check all(
              bid <- Gen.contract_bid(),
              !match?({:one, :clubs, _}, bid),
              next <- Gen.lower_bid(bid),
              table = %Table{bid: nil, next_bids: [bid, next]}
            ) do
        assert {:fail} == Table.validate(table)
      end
    end

    test "returns true for passes/doubles/redoubles" do
      check all(
              bid <- one_of([Gen.contract_bid(), Gen.pass()]),
              next <- Gen.action_bid(),
              table = %Table{bid: nil, next_bids: [bid, next]}
            ) do
        assert match?({:ok, ^table}, Table.validate(table))
      end
    end

    test "returns true for a redouble after a double" do
      check all(
              bid <- Gen.double(),
              next <- Gen.redouble(),
              table = %Table{bid: nil, next_bids: [bid, next]}
            ) do
        assert match?({:ok, ^table}, Table.validate(table))
      end
    end

    test "returns false for partners who double each others bids" do
      check all(
              bid <- one_of([Gen.contract_bid(), Gen.double(), Gen.redouble()]),
              pass <- Gen.pass(),
              next <- one_of([Gen.double(), Gen.redouble()]),
              table = %Table{bid: nil, next_bids: [bid, pass, next]}
            ) do
        assert match?({:fail}, Table.validate(table))
      end
    end

    test "returns false for a double after a double or redouble" do
      check all(
              bid <- one_of([Gen.double(), Gen.redouble()]),
              next <- one_of([Gen.double()]),
              table = %Table{bid: nil, next_bids: [bid, next]}
            ) do
        assert match?({:fail}, Table.validate(table))
      end
    end

    test "returns false for a redouble after a redouble" do
      check all(
              bid <- Gen.redouble(),
              next <- one_of([Gen.redouble(), Gen.double()]),
              table = %Table{bid: nil, next_bids: [bid, next]}
            ) do
        assert match?({:fail}, Table.validate(table))
      end
    end
  end
end
