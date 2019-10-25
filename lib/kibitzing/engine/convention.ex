defmodule Kibitzing.Engine.Convention do
  defstruct id: nil,
            name: nil,
            description: nil,
            requirements: []

  def new(id, name, description \\ nil) do
    %{id: id, name: name, description: description}
  end
end
