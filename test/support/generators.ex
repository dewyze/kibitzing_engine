defmodule Support.Generators do
  use ExUnitProperties

  alias Kibitzing.Engine.Convention.Requirement.{Level, Strain}
  alias Kibitzing.Engine.Convention.Table

  @spec n_bid() :: no_return
  def n_bid, do: bid(seats: [:N])
  @spec s_bid() :: no_return
  def s_bid, do: bid(seats: [:E])
  @spec e_bid() :: no_return
  def e_bid, do: bid(seats: [:W])
  @spec w_bid() :: no_return
  def w_bid, do: bid(seats: [:S])

  # TODO: Should generate passes as well
  @spec bid() :: no_return
  @spec bid(keyword()) :: no_return
  def bid(options \\ Keyword.new()) do
    other_bids = [:pass, :double, :redouble]
    only_levels = Keyword.get(options, :only_levels, Level.levels() ++ other_bids)
    ignore_levels = Keyword.get(options, :ignore_levels, [])
    only_strains = Keyword.get(options, :only_strains, Strain.strains() ++ other_bids)
    ignore_strains = Keyword.get(options, :ignore_strains, [])
    seats = Keyword.get(options, :seats, [:N, :E, :S, :W])
    levels = only_levels -- ignore_levels
    strains = only_strains -- ignore_strains

    gen all(
          level <- member_of(levels),
          strain <- member_of(strains),
          seat <- member_of(seats)
        ) do
      case {level, strain} do
        {:pass, :pass} ->
          {:pass, seat}

        {:double, :double} ->
          {:double, seat}

        {:redouble, :redouble} ->
          {:redouble, seat}

        _ ->
          {level, strain, seat}
      end
    end
  end

  @spec action_bid() :: no_return
  @spec action_bid(keyword()) :: no_return
  def action_bid(options \\ Keyword.new()) do
    only_actions = Keyword.get(options, :only, [:pass, :double, :redouble])
    ignore_actions = Keyword.get(options, :ignore, [])
    seats = Keyword.get(options, :seats, [:N, :E, :S, :W])
    actions = only_actions -- ignore_actions

    gen all(
          action <- member_of(actions),
          seat <- member_of(seats)
        ) do
      {action, seat}
    end
  end

  @spec pass :: no_return
  def pass do
    gen all(seat <- member_of([:N, :E, :S, :W])) do
      {:pass, seat}
    end
  end

  @spec double :: no_return
  def double do
    gen all(seat <- member_of([:N, :E, :S, :W])) do
      {:double, seat}
    end
  end

  @spec redouble :: no_return
  def redouble do
    gen all(seat <- member_of([:N, :E, :S, :W])) do
      {:redouble, seat}
    end
  end

  @spec bid_with_table() :: no_return
  @spec bid_with_table(keyword()) :: no_return
  def bid_with_table(options \\ Keyword.new()) do
    previous_bids = Keyword.get(options, :previous_bids, [])

    gen all(bid <- bid(options)) do
      %Table{bid: bid, previous_bids: previous_bids}
    end
  end

  @spec table() :: no_return
  @spec table(keyword()) :: no_return
  def table(options \\ Keyword.new()) do
    bid_gen = Keyword.get(options, :bid, bid())
    prev_gen = Keyword.get(options, :prev, list_of(bid()))
    next_gen = Keyword.get(options, :next, list_of(bid(), max_length: 35))

    gen all(bid <- bid_gen, prev <- prev_gen, next <- next_gen) do
      %Table{bid: bid, previous_bids: prev, next_bids: next}
    end
  end
end
