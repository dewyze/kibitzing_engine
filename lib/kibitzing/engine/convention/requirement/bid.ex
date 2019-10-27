defmodule Kibitzing.Engine.Convention.Requirement.Bid do
  alias Kibitzing.Engine.Convention.Requirement.UnreachableError
  alias Kibitzing.Engine.Convention.Table

  def pass(), do: &pass/1
  def pass(%Table{bid: bid}), do: match?({:pass, _}, bid)

  def double(), do: &double/1
  def double(%Table{bid: bid}), do: match?({:double, _}, bid)

  def redouble(), do: &redouble/1
  def redouble(%Table{bid: bid}), do: match?({:redouble, _}, bid)

  def from_prev_partner(), do: &from_prev_partner/1

  def from_prev_partner(%Table{previous_bids: bids}) when length(bids) >= 2 do
    {:ok, Enum.at(bids, 1)}
  end

  def from_prev_partner(_), do: {:error, :no_previous_bid}
end
