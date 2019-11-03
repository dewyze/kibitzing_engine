defmodule Kibitzing.Engine.Models.Table do
  defstruct previous_bids: [],
            bid: nil,
            next_bids: [],
            labeled_bids: Keyword.new()
end
