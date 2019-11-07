defmodule Kibitzing.Engine.Conventions.Opening do
  alias Kibitzing.Engine.Convention, as: Conv
  alias Kibitzing.Engine.Convention.Requirement.{Bid, Level, Strain, Trait}

  def two_over_one do
    Conv.new(:two_over_one, "2/1")
    |> Conv.bid([Trait.opening_bid(), Level.one(), Strain.suit()], label: :opener)
    |> Conv.pass()
    |> Conv.bid([Level.two(), Strain.lt(Bid.from_prev_partner())])
  end
end
