defmodule Kibitzing.Engine.Convention.Requirement.NodeTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Node
  alias Support.Generators, as: Gen
  alias Kibitzing.Engine.Convention.Node
  alias Kibitzing.Engine.Models.Table

  describe "#process - bid" do
    test "it returns {:ok, table} for a successful requirement" do
      check all(table <- Gen.table()) do
        req = fn _table -> true end
        node = %Node{requirements: [req], method: :bid}
        assert match?({:ok, %Table{}}, Node.process(table, node))
      end
    end

    test "it returns {:fail, table} for a failed requirement" do
      check all(table <- Gen.table()) do
        req = fn _table -> false end
        node = %Node{requirements: [req], method: :bid}
        assert match?({:fail, %Table{}}, Node.process(table, node))
      end
    end

    test "it moves the main bid to previous bids" do
      check all(%Table{bid: bid, previous_bids: prev} = table <- Gen.table()) do
        req = fn _table -> true end
        node = %Node{requirements: [req], method: :bid}

        assert match?(
                 {:ok, %Table{previous_bids: [^bid | ^prev]}},
                 Node.process(table, node)
               )
      end
    end

    test "it moves the first next bid to the main bid" do
      check all(
              %Table{next_bids: [h | t]} = table <-
                Gen.table(next: list_of(Gen.bid(), min_length: 1))
            ) do
        req = fn _table -> true end
        node = %Node{requirements: [req], method: :bid}

        assert match?(
                 {:ok, %Table{next_bids: ^t, bid: ^h}},
                 Node.process(table, node)
               )
      end
    end
  end

  describe "#process - one_of" do
    test "it returns {:ok, table} if one node is successful" do
      check all(table <- Gen.table()) do
        true_req = fn _table -> true end
        false_req = fn _table -> false end
        true_node = %Node{requirements: [true_req], method: :bid}
        false_node = %Node{requirements: [false_req], method: :bid}
        node = %Node{method: :one_of, nodes: [false_node, true_node]}
        assert match?({:ok, %Table{}}, Node.process(table, node))
      end
    end
  end
end
