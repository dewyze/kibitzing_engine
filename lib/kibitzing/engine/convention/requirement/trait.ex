defmodule Kibitzing.Engine.Convention.Requirement.Trait do
  alias Kibitzing.Engine.Models.{Level, Strain, Table}
  alias Kibitzing.Engine.Convention.Result

  def opening_bid, do: &opening_bid/1

  def opening_bid(%Table{previous_bids: previous_bids}) do
    Result.req(
      previous_bids == [] || Enum.all?(previous_bids, fn bid -> match?({:pass, _}, bid) end)
    )
  end

  def jump_shift, do: &jump_shift/1

  def jump_shift(%Table{bid: bid, previous_bids: previous_bids}) do
    with {level, strain, _} <- bid,
         true <- strain != :no_trump,
         {prev_level, prev_strain, _} <- Enum.find(previous_bids, &match?({_, _, _}, &1)) do
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
