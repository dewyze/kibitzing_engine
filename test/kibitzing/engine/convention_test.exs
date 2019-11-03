defmodule Kibitzing.Engine.ConventionTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention
  alias Kibitzing.Engine.{Convention, Convention.Node, Convention.Requirement.Bid}

  describe "new" do
    test "creates a convention" do
      convention = Convention.new(:two_over_one, "2/1", "2/1 Opening")

      assert convention.id == :two_over_one
      assert convention.name == "2/1"
      assert convention.description == "2/1 Opening"
    end
  end

  describe "#bid" do
    test "returns the convention with the added node" do
      check all(thing <- term()) do
        convention = Convention.new(:conv, "conv")

        assert match?(
                 %Convention{nodes: [%Node{method: :bid, requirements: [^thing]}]},
                 Convention.bid(convention, [thing])
               )
      end
    end
  end

  describe "#one_of" do
    test "returns the convention with the added node" do
      check all(
              thing_1 <- term(),
              thing_2 <- term()
            ) do
        convention = Convention.new(:conv, "conv")

        assert match?(
                 %Convention{nodes: [%Node{method: :one_of, nodes: [^thing_1, ^thing_2]}]},
                 Convention.one_of(convention, [thing_1, thing_2])
               )
      end
    end
  end

  describe "#pass" do
    test "returns the convention with a node with a pass requirements" do
      convention = Convention.pass(Convention.new(:conv, "conv"))
      node = hd(convention.nodes)
      assert node.requirements == [&Bid.pass/1]
    end
  end

  describe "#double" do
    test "returns the convention with a node with a double requirements" do
      convention = Convention.double(Convention.new(:conv, "conv"))
      node = hd(convention.nodes)
      assert node.requirements == [&Bid.double/1]
    end
  end

  describe "#redouble" do
    test "returns the convention with a node with a redouble requirements" do
      convention = Convention.redouble(Convention.new(:conv, "conv"))
      node = hd(convention.nodes)
      assert node.requirements == [&Bid.redouble/1]
    end
  end
end
