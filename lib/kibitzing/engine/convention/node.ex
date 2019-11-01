defmodule Kibitzing.Engine.Convention.Node do
  defstruct [:method, :requirements]
  alias Kibitzing.Engine.Convention.Requirement.Bid

  def bid(convention, requirements, options \\ Keyword.new()) do
    node(:bid, convention, requirements, options)
  end

  def one_of(convention, requirements, options \\ Keyword.new()) do
    node(:one_of, convention, requirements, options)
  end

  def pass(convention) do
    node(:bid, convention, [&Bid.pass/1])
  end

  def double(convention) do
    node(:bid, convention, [&Bid.double/1])
  end

  def redouble(convention) do
    node(:bid, convention, [&Bid.redouble/1])
  end

  defp node(method, convention, requirements, _options \\ Keyword.new()) do
    node = %__MODULE__{method: method, requirements: requirements}
    %{convention | nodes: convention.nodes ++ [node]}
  end
end
