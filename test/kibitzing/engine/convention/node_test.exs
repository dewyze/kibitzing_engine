defmodule Kibitzing.Engine.Convention.Requirement.NodeTest do
  use ExUnit.Case
  use ExUnitProperties
  # doctest Kibitzing.Engine.Convention.Node
  alias Support.Generators, as: Gen
  alias Kibitzing.Engine.Convention.Node
  alias Kibitzing.Engine.Models.Table
  alias Kibitzing.Engine.Convention.Requirement.{Level, Strain}

  describe "#process - bid" do
    test "it returns {:ok, table} for a successful requirement" do
      check all(table <- Gen.table()) do
        req = fn _table -> :ok end
        node = %Node{requirements: [req], method: :bid}
        assert match?({:ok, %Table{}}, Node.process(table, node))
      end
    end

    test "it returns {:fail, table} for a failed requirement" do
      check all(table <- Gen.table()) do
        req = fn _table -> :fail end
        node = %Node{requirements: [req], method: :bid}

        assert match?({:fail, %Table{}}, Node.process(table, node))
      end
    end

    test "it returns the original table with :next bids that fail" do
      check all(
              bids <- list_of(Gen.bid(ignore: [:seven]), min_length: 1),
              bid <- Gen.bid(ignore: [:seven]),
              table <- Gen.table(bid: constant(bid), next: constant(bids))
            ) do
        node = %Node{requirements: [&Level.seven/1], method: :bid}

        {status, result_table} = Node.process(table, node)

        assert status == :fail
        assert result_table.bid == bid
        assert result_table.next_bids == bids
      end
    end

    test "it moves the :okay bid to previous bids and first next_bid to main bid" do
      check all(
              seven_bid <- Gen.seven_bid(ignore: [:spades, :no_trump]),
              spade_bid <- Gen.spade_bid(ignore: [:seven]),
              table <- Gen.table()
            ) do
        previous_bids = table.previous_bids
        seven_spade_bid = {:seven, :spades, :E}
        after_bid = {:seven, :no_trump, :S}
        table = %Table{table | bid: seven_bid, next_bids: [spade_bid, seven_spade_bid, after_bid]}

        node = %Node{requirements: [&Strain.spades/1, &Level.seven/1], method: :bid}

        {status, result_table} = Node.process(table, node)

        assert status == :ok

        assert result_table.previous_bids == [
                 seven_spade_bid,
                 spade_bid,
                 seven_bid | previous_bids
               ]

        assert result_table.bid == after_bid
      end
    end

    test "adds a labeled bid to the table" do
      check all(%Table{bid: bid} = table <- Gen.table()) do
        req = fn _table -> :ok end
        node = %Node{requirements: [req], method: :bid, options: [{:label, :new_bid}]}
        table = %Table{table | labeled_bids: [{:my_bid, {:one, :spades, :N}}]}

        {status, result_table} = Node.process(table, node)

        assert status == :ok
        assert result_table.labeled_bids == [{:new_bid, bid}, {:my_bid, {:one, :spades, :N}}]
      end
    end
  end

  describe "#process - one_of" do
    test "it returns {:ok, table} if one node is successful" do
      check all(table <- Gen.table()) do
        true_req = fn _table -> :ok end
        false_req = fn _table -> :fail end
        true_node = %Node{requirements: [true_req], method: :bid}
        false_node = %Node{requirements: [false_req], method: :bid}
        node = %Node{method: :one_of, nodes: [false_node, true_node]}
        assert match?({:ok, %Table{}}, Node.process(table, node))
      end
    end
  end
end
