defmodule Kibitzing.Engine.Convention.Requirement.Bid do
  alias Kibitzing.Engine.Convention.Table

  def pass(), do: &pass/1
  def pass(%Table{bid: bid}), do: match?({:pass, _}, bid)

  def double(), do: &double/1
  def double(%Table{bid: bid}), do: match?({:double, _}, bid)
end
