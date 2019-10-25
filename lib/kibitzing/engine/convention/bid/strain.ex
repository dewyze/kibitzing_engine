defmodule Kibitzing.Engine.Convention.Bid.Strain do
  @suits [:spades, :hearts, :diamonds, :clubs]
  @strains [:no_trump] ++ @suits

  def strains do
    @strains
  end

  def no_trump, do: fn bid -> match?({_, :no_trump, _}, bid) end
  def spades, do: fn bid -> match?({_, :spades, _}, bid) end
  def hearts, do: fn bid -> match?({_, :hearts, _}, bid) end
  def diamonds, do: fn bid -> match?({_, :diamonds, _}, bid) end
  def clubs, do: fn bid -> match?({_, :clubs, _}, bid) end
end
