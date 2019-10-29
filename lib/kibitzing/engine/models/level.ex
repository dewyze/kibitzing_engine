defmodule Kibitzing.Engine.Models.Level do
  @all [:one, :two, :three, :four, :five, :six, :seven]

  def all do
    @all
  end

  def lower_levels({level, _, _}), do: lower_levels(level)

  def lower_levels(level) do
    Enum.take_while(@all, fn l -> l != level end)
  end

  def higher_levels({level, _, _}), do: higher_levels(level)

  def higher_levels(level) do
    tl(Enum.drop_while(@all, fn l -> l != level end))
  end
end
