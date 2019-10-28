defmodule Kibitzing.Engine.Models.StrainTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Models.Strain
  alias Kibitzing.Engine.Models.Strain

  describe "all" do
    test "returns all possible strains" do
      assert Strain.all() == [:clubs, :diamonds, :hearts, :spades, :no_trump]
    end
  end

  describe "suits" do
    test "returns all suits" do
      assert Strain.suits() == [:clubs, :diamonds, :hearts, :spades]
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
end
