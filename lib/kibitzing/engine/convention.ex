defmodule Kibitzing.Engine.Convention do
  defstruct id: nil,
            name: nil,
            description: nil,
            nodes: []

  alias Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Convention.Node
  alias Kibitzing.Engine.Models.Table

  def new(id, name, description \\ nil) do
    %__MODULE__{id: id, name: name, description: description, nodes: []}
  end

  def process(%__MODULE__{nodes: []}, table), do: table

  def process(%__MODULE__{nodes: nodes, id: id}, %Table{next_bids: [bid | bids]} = orig_table) do
    table = %{orig_table | bid: bid, next_bids: bids}

    with {:ok, _result} <- process_nodes(nodes, table) do
      %{orig_table | conventions: orig_table.conventions ++ [id]}
    else
      _ ->
        orig_table
    end
  end

  defp process_nodes([node | []], table) do
    Node.process(table, node)
  end

  defp process_nodes([node | nodes], orig_table) do
    with {:ok, table} <- Node.process(orig_table, node) do
      process_nodes(nodes, table)
    else
      _ ->
        {:fail}
    end
  end

  def bid(convention, requirements, options \\ Keyword.new()) do
    node(convention, :bid, requirements, options)
  end

  def one_of(convention, nodes, options \\ Keyword.new()) do
    node(convention, :one_of, nodes, options)
  end

  def pass(convention) do
    node(convention, :bid, [&Bid.pass/1])
  end

  def double(convention) do
    node(convention, :bid, [&Bid.double/1])
  end

  def redouble(convention) do
    node(convention, :bid, [&Bid.redouble/1])
  end

  defp node(convention, method, objs, options \\ Keyword.new()) do
    node = Node.new(method, objs, options)
    %{convention | nodes: convention.nodes ++ [node]}
  end
end
