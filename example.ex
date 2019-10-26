# alias Convention.Requirement
# alias Convention.Bid
# alias Convention.Bid.{Level, Strain}
Convention.new(:two_over_one, "Two Over One")
|> Node.bid([Trait.opening_bid(), Level.one(), Strain.suit()], label: :opener)
|> Node.pass()
|> Node.bid([
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
|> Node.bid([Trait.opening_bid(), Level.one(), Strain.suit()], label: :opening)
|> Node.or([
  Node.pass(),
  Node.double(),
  Node.bid([Level.one(), Strain.new(), Strain.suit()], label: :overcall)
])
|> Node.bid([Level.one(), Strain.new(), Strain.suit()], label: :response)
|> Node.bid([Trait.non_jump_shift(), Strain.new(), Strain.lte({:two, :hearts})])
|> Node.double()
|> Constraint.add([
  Constraint.suit_lengt(Strain.from(:response), :eq, 3)
])
|> Convention.complete()
