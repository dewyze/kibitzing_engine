defmodule Kibitzing.Engine.Models.Strain do
  @majors [:hearts, :spades]
  @minors [:clubs, :diamonds]
  @suits @minors ++ @majors
  @all @suits ++ [:no_trump]

  def all do
    @all
  end

  def majors do
    @majors
  end

  def minors do
    @minors
  end

  def suits do
    @suits
  end

  def lower_strains({_, strain, _}), do: lower_strains(strain)

  def lower_strains(strain) do
    Enum.take_while(@all, fn s -> s != strain end)
  end

  def higher_strains({_, strain, _}), do: higher_strains(strain)

  def higher_strains(strain) do
    tl(Enum.drop_while(@all, fn s -> s != strain end))
  end
end
