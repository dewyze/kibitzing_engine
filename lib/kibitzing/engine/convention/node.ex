defmodule Kibitzing.Engine.Convention.Node do
  defstruct [:method, :requirements, :nodes]

  alias Kibitzing.Engine.Models.Table

  def new(method, objs, _options \\ Keyword.new()) do
    case method do
      :bid ->
        %__MODULE__{method: :bid, requirements: objs}

      :one_of ->
        %__MODULE__{method: :one_of, nodes: objs}
    end
  end

  def process(table, %__MODULE__{method: :bid, requirements: reqs}) do
    %Table{bid: bid, previous_bids: prev, next_bids: next} = table

    if Enum.all?(reqs, fn req -> req.(table) end) do
      case next do
        [] ->
          {:ok, %Table{previous_bids: [bid | prev], bid: nil, next_bids: []}}

        [h | t] ->
          {:ok, %Table{previous_bids: [bid | prev], bid: h, next_bids: t}}
      end
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
end
