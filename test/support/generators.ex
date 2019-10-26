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
    only_levels = Keyword.get(options, :only_levels, Level.levels() ++ [:pass])
    ignore_levels = Keyword.get(options, :ignore_levels, [])
    only_strains = Keyword.get(options, :only_strains, Strain.strains() ++ [:pass])
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

        _ ->
          {level, strain, seat}
      end
    end
  end

  @spec pass :: no_return
  def pass do
    gen all(seat <- member_of([:N, :E, :S, :W])) do
      {:pass, seat}
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
end
