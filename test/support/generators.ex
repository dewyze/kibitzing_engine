defmodule Support.Generators do
  use ExUnitProperties

  alias Kibitzing.Engine.Models.{Level, Strain, Table}
  alias Kibitzing.Engine.Convention.Requirement.{UnreachableError}

  @spec n_bid() :: no_return
  def n_bid, do: bid(seats: [:N])
  @spec s_bid() :: no_return
  def s_bid, do: bid(seats: [:E])
  @spec e_bid() :: no_return
  def e_bid, do: bid(seats: [:W])
  @spec w_bid() :: no_return
  def w_bid, do: bid(seats: [:S])

  @spec contract_bid() :: no_return
  @spec contract_bid(keyword()) :: no_return
  def contract_bid(options \\ Keyword.new()) do
    all_levels = Level.all()
    all_strains = Strain.all()

    only = Keyword.get(options, :only, [])
    ignore = Keyword.get(options, :ignore, [])

    only_levels = Enum.filter(only, &Enum.member?(all_levels, &1))
    only_strains = Enum.filter(only, &Enum.member?(all_strains, &1))

    ignore_levels = Enum.filter(ignore, &Enum.member?(all_levels, &1))
    ignore_strains = Enum.filter(ignore, &Enum.member?(all_strains, &1))

    levels =
      case only_levels do
        [] -> all_levels -- ignore_levels
        _ -> only_levels
      end

    strains =
      case only_strains do
        [] -> all_strains -- ignore_strains
        _ -> only_strains
      end

    seats = Keyword.get(options, :seats, [:N, :E, :S, :W])

    gen all(
          level <- member_of(levels),
          strain <- member_of(strains),
          seat <- member_of(seats)
        ) do
      {level, strain, seat}
    end
  end

  @spec suit_bid() :: no_return
  @spec suit_bid(keyword()) :: no_return
  def suit_bid(options \\ Keyword.new()) do
    ignore = Keyword.get(options, :ignore, []) ++ [:no_trump]

    contract_bid(ignore: ignore)
  end

  # Define helpers for all levels/suits
  (Strain.all() ++ Level.all())
  |> Enum.map(fn n -> {:"#{String.trim_trailing(Atom.to_string(n), "s")}_bid", n} end)
  |> Enum.each(fn {method, filter} ->
    @spec unquote(method)() :: no_return
    @spec unquote(method)(keyword()) :: no_return
    def unquote(method)(options \\ Keyword.new()) do
      ignore = Keyword.get(options, :ignore, [])

      contract_bid(only: [unquote(filter)], ignore: ignore)
    end
  end)

  @spec action_bid() :: no_return
  @spec action_bid(keyword()) :: no_return
  def action_bid(options \\ Keyword.new()) do
    all_actions = [:pass, :double, :redouble]

    only = Keyword.get(options, :only, [])
    ignore = Keyword.get(options, :ignore, [])

    only_actions = Enum.filter(only, &Enum.member?(all_actions, &1))
    ignore_actions = Enum.filter(ignore, &Enum.member?(all_actions, &1))

    actions =
      case only_actions do
        [] -> all_actions -- ignore_actions
        _ -> only_actions
      end

    seats = Keyword.get(options, :seats, [:N, :E, :S, :W])

    if Enum.empty?(actions) do
      raise UnreachableError,
        message:
          "No possible actions are available, consider using &Support.Generators.contract_bid/1 instead"
    end

    gen all(
          action <- member_of(actions),
          seat <- member_of(seats)
        ) do
      {action, seat}
    end
  end

  @spec jump_shift(any()) :: no_return
  def jump_shift({level, strain, _}) do
    seats = [:N, :E, :S, :W]

    gen all(
          level <- member_of(Level.higher_levels(level)),
          strain <- member_of(Strain.higher_strains(strain)),
          seat <- member_of(seats)
        ) do
      {level, strain, seat}
    end
  end

  @spec bid() :: no_return
  @spec bid(keyword()) :: no_return
  def bid(options \\ Keyword.new()) do
    gen all(bid <- one_of([contract_bid(options), action_bid(options)])) do
      bid
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
