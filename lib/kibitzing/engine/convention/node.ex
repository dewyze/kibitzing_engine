defmodule Kibitzing.Engine.Convention.Node do
  defstruct [:method, :requirements]

  def new(method, requirements, _options \\ Keyword.new()) do
    %__MODULE__{method: method, requirements: requirements}
  end
end
