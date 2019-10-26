defmodule Kibitzing.Engine.Convention.Bid.Strain do
  alias Kibitzing.Engine.Convention.Table

  @majors [:spades, :hearts]
  @minors [:diamonds, :clubs]
  @suits @majors ++ @minors
  @strains [:no_trump] ++ @suits

  def strains do
    @strains
  end

  def majors do
    @majors
  end

  def minors do
    @minors
  end

  def no_trump, do: &no_trump/1
  def no_trump(table), do: match?(%Table{bid: {_, :no_trump, _}}, table)

  def spades, do: &spades/1
  def spades(%Table{bid: bid}), do: match?({_, :spades, _}, bid)

  def hearts, do: &hearts/1
  def hearts(%Table{bid: bid}), do: match?({_, :hearts, _}, bid)

  def diamonds, do: &diamonds/1
  def diamonds(%Table{bid: bid}), do: match?({_, :diamonds, _}, bid)

  def clubs, do: &clubs/1
  def clubs(%Table{bid: bid}), do: match?({_, :clubs, _}, bid)

  def major, do: &major/1
  def major(%Table{bid: {_, strain, _}}), do: Enum.member?(@majors, strain)
  def major(_), do: false

  def minor, do: &minor/1
  def minor(%Table{bid: {_, strain, _}}), do: Enum.member?(@minors, strain)
  def minor(_), do: false

  def suit, do: &suit/1
  def suit(%Table{bid: {_, strain, _}}), do: Enum.member?(@suits, strain)
  def suit(_), do: false
end
