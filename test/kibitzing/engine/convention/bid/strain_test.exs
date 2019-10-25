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

  describe "majors" do
    test "returns all possible strains" do
      assert Strain.majors() == [:spades, :hearts]
    end
  end

  describe "minors" do
    test "returns all possible strains" do
      assert Strain.minors() == [:diamonds, :clubs]
    end
  end

  describe "no_trump" do
    test "returns a function that asserts if a bid is no trump" do
      check all(bid <- Gen.bid(only_strains: [:no_trump])) do
        assert Strain.no_trump().(bid)
      end
    end

    test "returns a function that fails if a bid is not no trump" do
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

    test "returns a function that fails if a bid is not spades" do
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

    test "returns a function that fails if a bid is not hearts" do
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

    test "returns a function that fails if a bid is not diamonds" do
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

    test "returns a function that fails if a bid is not clubs" do
      check all(bid <- Gen.bid(ignore_strains: [:clubs])) do
        refute Strain.clubs().(bid)
      end
    end
  end

  describe "major" do
    test "returns a function that asserts if a bid is a major" do
      check all(bid <- Gen.bid(only_strains: Strain.majors())) do
        assert Strain.major().(bid)
      end
    end

    test "returns a function that fails if a bid is not a major" do
      check all(bid <- Gen.bid(ignore_strains: Strain.majors())) do
        refute Strain.major().(bid)
      end
    end
  end

  describe "minor" do
    test "returns a function that asserts if a bid is a minor" do
      check all(bid <- Gen.bid(only_strains: Strain.minors())) do
        assert Strain.minor().(bid)
      end
    end

    test "returns a function that fails if a bid is not a minor" do
      check all(bid <- Gen.bid(ignore_strains: Strain.minors())) do
        refute Strain.minor().(bid)
      end
    end
  end

  describe "suit" do
    test "returns a function that asserts if a bid is a suit" do
      check all(bid <- Gen.bid(ignore_strains: [:no_trump])) do
        assert Strain.suit().(bid)
      end
    end

    test "returns a function that fails if a bid is no trump" do
      check all(bid <- Gen.bid(only_strains: [:no_trump])) do
        refute Strain.suit().(bid)
      end
    end
  end
end
