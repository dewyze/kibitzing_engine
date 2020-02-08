defmodule Kibitzing.Engine.Convention.Requirement.Bid do
  alias Kibitzing.Engine.Models.{Bid, Table}
  alias Kibitzing.Engine.Convention.Result

  def exact(exact_bid), do: fn table -> exact(exact_bid, table) end
  def exact({level, strain}, %Table{bid: {level, strain, _}}), do: :ok
  def exact(_, %Table{}), do: :fail

  def pass(), do: &pass/1
  def pass(%Table{bid: bid}), do: Result.opt(Bid.pass?(bid))

  def double(), do: &double/1
  def double(%Table{bid: bid}), do: Result.opt(Bid.double?(bid))

  def redouble(), do: &redouble/1
  def redouble(%Table{bid: bid}), do: Result.opt(Bid.redouble?(bid))

  def first_bid(), do: &first_bid/1
  def first_bid(%Table{previous_bids: prev}) when length(prev) < 4, do: :ok
  def first_bid(%Table{}), do: :fail

  def from_prev_partner(), do: &from_prev_partner/1

  def from_prev_partner(%Table{previous_bids: bids}) when length(bids) >= 2 do
    {:ok, Enum.at(bids, 1)}
  end

  def from_prev_partner(_), do: {:error, :no_previous_bid}
end
