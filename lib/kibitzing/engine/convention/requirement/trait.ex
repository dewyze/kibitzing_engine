defmodule Kibitzing.Engine.Convention.Requirement.Trait do
  alias Kibitzing.Engine.Models.{Bid, Level, Strain, Table}
  alias Kibitzing.Engine.Convention.Result

  def opening_bid, do: &opening_bid/1

  def opening_bid(%Table{bid: {:pass, _}, previous_bids: previous_bids}) do
    Result.skip(passes_or_empty?(previous_bids))
  end

  def opening_bid(%Table{bid: {_, _, _}, previous_bids: previous_bids}) do
    Result.req(passes_or_empty?(previous_bids))
  end

  def opening_bid(_), do: :fail

  defp passes_or_empty?(previous_bids) do
    previous_bids == [] || Enum.all?(previous_bids, &Bid.pass?/1)
  end

  def jump_shift, do: &jump_shift/1

  def jump_shift(%Table{bid: bid, previous_bids: previous_bids}) do
    with {level, strain, _} <- bid,
         true <- strain != :no_trump,
         {prev_level, prev_strain, _} <- Enum.find(previous_bids, &Bid.contract_bid?/1) do
      result =
        Level.higher?(level, prev_level) &&
          Strain.higher?(strain, prev_strain)

      Result.opt(result)
    else
      _ ->
        :next
    end
  end
end
