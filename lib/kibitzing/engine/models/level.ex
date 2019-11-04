defmodule Kibitzing.Engine.Models.Level do
  @all [:one, :two, :three, :four, :five, :six, :seven]

  def all do
    @all
  end

  def higher?({level_1, _, _}, {level_2, _, _}), do: higher?(level_1, level_2)

  def higher?(level_1, level_2) do
    index(level_1) > index(level_2)
  end

  def lower?({level_1, _, _}, {level_2, _, _}), do: lower?(level_1, level_2)

  def lower?(level_1, level_2) do
    index(level_1) < index(level_2)
  end

  def equal?({level, _, _}, {level, _, _}), do: true
  def equal?(_, _), do: false

  def lte?(bid_1, bid_2) do
    lower?(bid_1, bid_2) || equal?(bid_1, bid_2)
  end

  def gte?(bid_1, bid_2), do: hte?(bid_1, bid_2)

  def hte?(bid_1, bid_2) do
    higher?(bid_1, bid_2) || equal?(bid_1, bid_2)
  end

  defp index(level) do
    Enum.find_index(@all, &(&1 == level))
  end

  def lower_levels({level, _, _}), do: lower_levels(level)

  def lower_levels(level) do
    Enum.take_while(@all, &(&1 != level))
  end

  def higher_levels({level, _, _}), do: higher_levels(level)

  def higher_levels(level) do
    tl(Enum.drop_while(@all, &(&1 != level)))
  end
end
