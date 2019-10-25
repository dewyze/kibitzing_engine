defmodule Kibitzing.Engine.Convention.Bid.Level do
  @levels [:one, :two, :three, :four, :five, :six, :seven]

  def levels do
    @levels
  end

  def one, do: fn bid -> match?({:one, _, _}, bid) end
  def two, do: fn bid -> match?({:two, _, _}, bid) end
  def three, do: fn bid -> match?({:three, _, _}, bid) end
  def four, do: fn bid -> match?({:four, _, _}, bid) end
  def five, do: fn bid -> match?({:five, _, _}, bid) end
  def six, do: fn bid -> match?({:six, _, _}, bid) end
  def seven, do: fn bid -> match?({:seven, _, _}, bid) end
end
