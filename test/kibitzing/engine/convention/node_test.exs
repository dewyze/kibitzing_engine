defmodule Kibitzing.Engine.Convention.Requirement.NodeTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Node
  alias Kibitzing.Engine.{Convention, Convention.Node}
  alias Kibitzing.Engine.Convention.Requirement.Bid

  describe "#bid" do
    test "returns the convention with the added node" do
      check all(thing <- term()) do
        convention = Convention.new(:conv, "conv")

        assert match?(
                 %Convention{nodes: [%Node{method: :bid, requirements: [^thing]}]},
                 Node.bid(convention, [thing])
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
                 %Convention{nodes: [%Node{method: :one_of, requirements: [^thing_1, ^thing_2]}]},
                 Node.one_of(convention, [thing_1, thing_2])
               )
      end
    end
  end

  describe "#pass" do
    test "returns the convention with a node with a pass requirements" do
      convention = Node.pass(Convention.new(:conv, "conv"))
      node = hd(convention.nodes)
      assert node.requirements == [&Bid.pass/1]
    end
  end

  describe "#double" do
    test "returns the convention with a node with a double requirements" do
      convention = Node.double(Convention.new(:conv, "conv"))
      node = hd(convention.nodes)
      assert node.requirements == [&Bid.double/1]
    end
  end

  describe "#redouble" do
    test "returns the convention with a node with a redouble requirements" do
      convention = Node.redouble(Convention.new(:conv, "conv"))
      node = hd(convention.nodes)
      assert node.requirements == [&Bid.redouble/1]
    end
  end
end
