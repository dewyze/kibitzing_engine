defmodule Kibitzing.Engine.Conventions.Opening do
  alias Kibitzing.Engine.Convention, as: Conv
  alias Kibitzing.Engine.Convention.Requirement.{Bid, Level, Strain, Trait}

  def two_over_one do
    Conv.new(:two_over_one, "2/1")
    |> Conv.bid([Trait.first_bid(), Trait.opening_bid(), Level.one(), Strain.suit()],
      label: :opener
    )
    |> Conv.pass()
    |> Conv.bid([Trait.first_bid(), Level.two(), Strain.lt(Bid.from_prev_partner())])
  end

  def strong_two_clubs do
    Conv.new(:strong_two_clubs, "Strong Two Clubs")
    |> Conv.bid([Trait.first_bid(), Trait.opening_bid(), Bid.exact({:two, :clubs})])
  end
end
