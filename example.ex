# alias Convention.Requirement
# alias Convention.Bid
# alias Convention.Bid.{Level, Strain}
Convention.new(:two_over_one, "Two Over One")
|> Bid.bid([Trait.opening_bid(), Level.one(), Strain.suit()], label: :opener)
|> Bid.pass()
|> Bid.bid([
  Level.two(),
  # Or Trait.non_jump_shift() + Strain.new() + Strain.suit()
  Strain.lt(Bid.previous_partner())
])
|> Constraint.add([
  Constraint.hcp(:gte, 12),
  # Calls Bid.from(:opener).strain
  Constraint.suit_length(Strain.from(:opener), :lte, 3)
])
|> Convention.complete()

Convention.new(:support_double, "Support Double")
|> Bid.bid([Trait.opening_bid(), Level.one(), Strain.suit()], label: :opening)
|> Bid.or([
  Bid.pass(),
  Bid.double(),
  Bid.bid([Level.one(), Strain.new(), Strain.suit()], label: :overcall)
])
|> Bid.bid([Level.one(), Strain.new(), Strain.suit()], label: :response)
|> Bid.bid([Trait.non_jump_shift(), Strain.new(), Strain.lte({:two, :hearts})])
|> Bid.double()
|> Constraint.add([
  Constraint.suit_lengt(Strain.from(:response), :eq, 3)
])
|> Convention.complete()
