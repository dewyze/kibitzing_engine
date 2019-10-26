defmodule Kibitzing.Engine.Convention.Requirement.Level do
  alias Kibitzing.Engine.Convention.Table

  @levels [:one, :two, :three, :four, :five, :six, :seven]

  def levels do
    @levels
  end

  def one, do: &one/1
  def one(%Table{bid: bid}), do: match?({:one, _, _}, bid)

  def two, do: &two/1
  def two(%Table{bid: bid}), do: match?({:two, _, _}, bid)

  def three, do: &three/1
  def three(%Table{bid: bid}), do: match?({:three, _, _}, bid)

  def four, do: &four/1
  def four(%Table{bid: bid}), do: match?({:four, _, _}, bid)

  def five, do: &five/1
  def five(%Table{bid: bid}), do: match?({:five, _, _}, bid)

  def six, do: &six/1
  def six(%Table{bid: bid}), do: match?({:six, _, _}, bid)

  def seven, do: &seven/1
  def seven(%Table{bid: bid}), do: match?({:seven, _, _}, bid)
end
