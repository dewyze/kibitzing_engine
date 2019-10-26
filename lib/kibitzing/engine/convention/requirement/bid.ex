defmodule Kibitzing.Engine.Convention.Requirement.Bid do
  alias Kibitzing.Engine.Convention.Table

  def pass(), do: &pass/1
  def pass(%Table{bid: bid}), do: match?({:pass, _}, bid)
end
