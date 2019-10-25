defmodule Kibitzing.Engine.Convention.Bid.StrainTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Bid.Strain
  alias Kibitzing.Engine.Convention.Bid.Strain
  alias Support.Generators, as: Gen

  describe "strains" do
    test "returns all possible strains" do
      assert Strain.strains() == [:no_trump, :spades, :hearts, :diamonds, :clubs]
    end
  end

  describe "no_trump" do
    test "returns a function that asserts if a bid is no trump" do
      check all(bid <- Gen.bid(only_strains: [:no_trump])) do
        assert Strain.no_trump().(bid)
      end
    end

    test "returns a function that refutes if a bid is not no trump" do
      check all(bid <- Gen.bid(ignore_strains: [:no_trump])) do
        refute Strain.no_trump().(bid)
      end
    end
  end

  describe "spades" do
    test "returns a function that asserts if a bid is spades trump" do
      check all(bid <- Gen.bid(only_strains: [:spades])) do
        assert Strain.spades().(bid)
      end
    end

    test "returns a function that refutes if a bid is not spades" do
      check all(bid <- Gen.bid(ignore_strains: [:spades])) do
        refute Strain.spades().(bid)
      end
    end
  end

  describe "hearts" do
    test "returns a function that asserts if a bid is hearts trump" do
      check all(bid <- Gen.bid(only_strains: [:hearts])) do
        assert Strain.hearts().(bid)
      end
    end

    test "returns a function that refutes if a bid is not hearts" do
      check all(bid <- Gen.bid(ignore_strains: [:hearts])) do
        refute Strain.hearts().(bid)
      end
    end
  end

  describe "diamonds" do
    test "returns a function that asserts if a bid is diamonds trump" do
      check all(bid <- Gen.bid(only_strains: [:diamonds])) do
        assert Strain.diamonds().(bid)
      end
    end

    test "returns a function that refutes if a bid is not diamonds" do
      check all(bid <- Gen.bid(ignore_strains: [:diamonds])) do
        refute Strain.diamonds().(bid)
      end
    end
  end

  describe "clubs" do
    test "returns a function that asserts if a bid is clubs trump" do
      check all(bid <- Gen.bid(only_strains: [:clubs])) do
        assert Strain.clubs().(bid)
      end
    end

    test "returns a function that refutes if a bid is not clubs" do
      check all(bid <- Gen.bid(ignore_strains: [:clubs])) do
        refute Strain.clubs().(bid)
      end
    end
  end
end
