defmodule Kibitzing.Engine.Convention do
  defstruct id: nil,
            name: nil,
            description: nil,
            nodes: []

  alias Kibitzing.Engine.Convention.Requirement.Bid
  alias Kibitzing.Engine.Convention.Node

  def new(id, name, description \\ nil) do
    %__MODULE__{id: id, name: name, description: description, nodes: []}
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

  defp node(convention, method, requirements, options \\ Keyword.new()) do
    node = Node.new(method, requirements, options)
    %{convention | nodes: convention.nodes ++ [node]}
  end
end
