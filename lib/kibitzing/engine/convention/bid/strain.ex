defmodule Kibitzing.Engine.Convention.Bid.Strain do
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

  def no_trump, do: fn bid -> match?({_, :no_trump, _}, bid) end
  def spades, do: fn bid -> match?({_, :spades, _}, bid) end
  def hearts, do: fn bid -> match?({_, :hearts, _}, bid) end
  def diamonds, do: fn bid -> match?({_, :diamonds, _}, bid) end
  def clubs, do: fn bid -> match?({_, :clubs, _}, bid) end

  def major, do: fn {_, strain, _} -> Enum.member?(@majors, strain) end
  def minor, do: fn {_, strain, _} -> Enum.member?(@minors, strain) end
  def suit, do: fn {_, strain, _} -> Enum.member?(@suits, strain) end
end
