defmodule Kibitzing.Engine.Convention do
  defstruct id: nil,
            name: nil,
            description: nil,
            nodes: []

  def new(id, name, description \\ nil) do
    %__MODULE__{id: id, name: name, description: description, nodes: []}
  end
end
