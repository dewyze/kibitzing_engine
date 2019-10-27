defmodule Kibitzing.Engine.Convention.Requirement.Bid do
  alias Kibitzing.Engine.Convention.Requirement.UnreachableError
  alias Kibitzing.Engine.Convention.Table

  def pass(), do: &pass/1
  def pass(%Table{bid: bid}), do: match?({:pass, _}, bid)

  def double(), do: &double/1
  def double(%Table{bid: bid}), do: match?({:double, _}, bid)

  def redouble(), do: &redouble/1
  def redouble(%Table{bid: bid}), do: match?({:redouble, _}, bid)

  def previous_partner(), do: &previous_partner/1

  def previous_partner(%Table{previous_bids: bids}) when length(bids) >= 2 do
    Enum.at(bids, 1)
  end

  def previous_partner(_), do: raise(UnreachableError)
end
