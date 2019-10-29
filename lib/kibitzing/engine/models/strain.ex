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

  def higher?({_, strain_1, _}, {_, strain_2, _}), do: higher?(strain_1, strain_2)

  def higher?(strain_1, strain_2) do
    index(strain_1) > index(strain_2)
  end

  def lower?({_, strain_1, _}, {_, strain_2, _}), do: lower?(strain_1, strain_2)

  def lower?(strain_1, strain_2) do
    index(strain_1) < index(strain_2)
  end

  defp index(strain) do
    Enum.find_index(@all, &(&1 == strain))
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
