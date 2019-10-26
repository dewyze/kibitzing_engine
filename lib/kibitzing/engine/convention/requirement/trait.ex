defmodule Kibitzing.Engine.Convention.Requirement.Trait do
  alias Kibitzing.Engine.Convention.Table

  def opening_bid, do: &opening_bid/1

  def opening_bid(%Table{previous_bids: previous_bids}) do
    previous_bids == [] || Enum.all?(previous_bids, fn bid -> match?({:pass, _}, bid) end)
  end
end
