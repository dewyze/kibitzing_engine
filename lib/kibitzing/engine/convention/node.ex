defmodule Kibitzing.Engine.Convention.Node do
  defstruct method: nil,
            requirements: [],
            nodes: [],
            options: Keyword.new()

  alias Kibitzing.Engine.Models.Table

  def new(method, objs, options \\ Keyword.new()) do
    case method do
      :bid ->
        %__MODULE__{method: :bid, requirements: objs, options: options}

      :one_of ->
        %__MODULE__{method: :one_of, nodes: objs, options: options}
    end
  end

  def process(table, %__MODULE__{method: :bid, requirements: reqs, options: options}) do
    if Enum.all?(reqs, fn req -> req.(table) end) do
      advance_table(table, options)
    else
      {:fail, table}
    end
  end

  def process(table, %__MODULE__{method: :one_of, nodes: nodes}) do
    Enum.find_value(nodes, {:fail, table}, fn node ->
      result = process(table, node)
      match?({:ok, _}, result) && result
    end)
  end

  defp advance_table(
         %Table{bid: bid, previous_bids: prev, next_bids: next, labeled_bids: labeled},
         options
       ) do
    labeled =
      if Keyword.has_key?(options, :label) do
        Keyword.put(labeled, Keyword.fetch!(options, :label), bid)
      end

    case next do
      [] ->
        {:ok, %Table{previous_bids: [bid | prev], bid: nil, next_bids: [], labeled_bids: labeled}}

      [h | t] ->
        {:ok, %Table{previous_bids: [bid | prev], bid: h, next_bids: t, labeled_bids: labeled}}
    end
  end
end
