defmodule Kibitzing.Engine.Models.Bid do
  alias Kibitzing.Engine.Models.{Level, Strain}

  def pass?({:pass, _}), do: true
  def pass?(_), do: false

  def double?({:double, _}), do: true
  def double?(_), do: false

  def redouble?({:redouble, _}), do: true
  def redouble?(_), do: false

  def action?(bid) do
    pass?(bid) || double?(bid) || redouble?(bid)
  end

  def higher?(bid_1, bid_2) do
    cond do
      (Level.equal?(bid_1, bid_2) && Strain.higher?(bid_1, bid_2)) ||
          Level.higher?(bid_1, bid_2) ->
        true

      true ->
        false
    end
  end

  def lower?(bid_1, bid_2) do
    cond do
      (Level.equal?(bid_1, bid_2) && Strain.lower?(bid_1, bid_2)) ||
          Level.lower?(bid_1, bid_2) ->
        true

      true ->
        false
    end
  end
end
