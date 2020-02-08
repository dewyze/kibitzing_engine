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

  def process(orig_table, %__MODULE__{method: :bid, requirements: reqs, options: options}) do
    bids = [orig_table.bid | orig_table.next_bids]

    # TODO: REFACTOR
    {status, table} =
      Enum.reduce_while(bids, {:fail, orig_table}, fn _, {_, t} ->
        meets_req =
          Enum.reduce_while(reqs, :fail, fn req, _ ->
            case(req.(t)) do
              :fail ->
                {:halt, :fail}

              :next ->
                {:halt, :next}

              :ok ->
                {:cont, :ok}
            end
          end)

        case meets_req do
          :ok ->
            {:halt, {:ok, t}}

          :next ->
            {:cont, {:fail, advance_table(t)}}

          :fail ->
            {:halt, {:fail, orig_table}}
        end
      end)

    case status do
      :ok ->
        {:ok, advance_table(table, options)}

      _ ->
        {:fail, orig_table}
    end
  end

  def process(table, %__MODULE__{method: :one_of, nodes: nodes}) do
    Enum.find_value(nodes, {:fail, table}, fn node ->
      result = process(table, node)
      match?({:ok, _}, result) && result
    end)
  end

  defp advance_table(
         table = %Table{bid: bid, previous_bids: prev, next_bids: next, labeled_bids: labeled},
         options \\ Keyword.new()
       ) do
    labeled =
      if Keyword.has_key?(options, :label) do
        Keyword.put(labeled, Keyword.fetch!(options, :label), bid)
      else
        labeled
      end

    case next do
      [] ->
        %{table | previous_bids: [bid | prev], bid: nil, next_bids: [], labeled_bids: labeled}

      [h | t] ->
        %{table | previous_bids: [bid | prev], bid: h, next_bids: t, labeled_bids: labeled}
    end
  end
end
