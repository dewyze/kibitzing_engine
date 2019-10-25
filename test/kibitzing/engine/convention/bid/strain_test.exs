defmodule Kibitzing.Engine.Convention.Bid.StrainTest do
  use ExUnit.Case
  use ExUnitProperties
  alias Support.Generators, as: Gen
  # doctest Kibitzing.Engine.Convention.Bid.Strain
  alias Kibitzing.Engine.Convention.Bid.Strain
  alias Kibitzing.Engine.Convention.Table

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
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.no_trump().(table) == Strain.no_trump(table)
      end
    end

    test "returns a function that asserts if a bid is no trump" do
      check all(table <- Gen.bid_with_table(only_strains: [:no_trump])) do
        assert Strain.no_trump(table)
      end
    end

    test "returns a function that fails if a bid is not no trump" do
      check all(table <- Gen.bid_with_table(ignore_strains: [:no_trump])) do
        refute Strain.no_trump(table)
      end
    end
  end

  describe "spades" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.spades().(table) == Strain.spades(table)
      end
    end

    test "returns a function that asserts if a bid is spades trump" do
      check all(table <- Gen.bid_with_table(only_strains: [:spades])) do
        assert Strain.spades(table)
      end
    end

    test "returns a function that fails if a bid is not spades" do
      check all(table <- Gen.bid_with_table(ignore_strains: [:spades])) do
        refute Strain.spades(table)
      end
    end
  end

  describe "hearts" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.hearts().(table) == Strain.hearts(table)
      end
    end

    test "returns a function that asserts if a bid is hearts trump" do
      check all(table <- Gen.bid_with_table(only_strains: [:hearts])) do
        assert Strain.hearts(table)
      end
    end

    test "returns a function that fails if a bid is not hearts" do
      check all(table <- Gen.bid_with_table(ignore_strains: [:hearts])) do
        refute Strain.hearts(table)
      end
    end
  end

  describe "diamonds" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.diamonds().(table) == Strain.diamonds(table)
      end
    end

    test "returns a function that asserts if a bid is diamonds trump" do
      check all(table <- Gen.bid_with_table(only_strains: [:diamonds])) do
        assert Strain.diamonds(table)
      end
    end

    test "returns a function that fails if a bid is not diamonds" do
      check all(table <- Gen.bid_with_table(ignore_strains: [:diamonds])) do
        refute Strain.diamonds(table)
      end
    end
  end

  describe "clubs" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.clubs().(table) == Strain.clubs(table)
      end
    end

    test "returns a function that asserts if a bid is clubs trump" do
      check all(table <- Gen.bid_with_table(only_strains: [:clubs])) do
        assert Strain.clubs(table)
      end
    end

    test "returns a function that fails if a bid is not clubs" do
      check all(table <- Gen.bid_with_table(ignore_strains: [:clubs])) do
        refute Strain.clubs(table)
      end
    end
  end

  describe "major" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.major().(table) == Strain.major(table)
      end
    end

    test "returns a function that asserts if a bid is a major" do
      check all(table <- Gen.bid_with_table(only_strains: Strain.majors())) do
        assert Strain.major(table)
      end
    end

    test "returns a function that fails if a bid is not a major" do
      check all(table <- Gen.bid_with_table(ignore_strains: Strain.majors())) do
        refute Strain.major(table)
      end
    end
  end

  describe "minor" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.minor().(table) == Strain.minor(table)
      end
    end

    test "returns a function that asserts if a bid is a minor" do
      check all(table <- Gen.bid_with_table(only_strains: Strain.minors())) do
        assert Strain.minor(table)
      end
    end

    test "returns a function that fails if a bid is not a minor" do
      check all(table <- Gen.bid_with_table(ignore_strains: Strain.minors())) do
        refute Strain.minor(table)
      end
    end
  end

  describe "suit" do
    test "with no args returns the same as with args" do
      check all(table <- Gen.bid_with_table()) do
        assert Strain.suit().(table) == Strain.suit(table)
      end
    end

    test "returns a function that asserts if a bid is a suit" do
      check all(table <- Gen.bid_with_table(ignore_strains: [:no_trump])) do
        assert Strain.suit(table)
      end
    end

    test "returns a function that fails if a bid is no trump" do
      check all(table <- Gen.bid_with_table(only_strains: [:no_trump])) do
        refute Strain.suit(table)
      end
    end
  end
end