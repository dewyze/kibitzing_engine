defmodule Kibitzing.Engine.Models.Bid do
  def pass?({:pass, _}), do: true
  def pass?(_), do: false

  def double?({:double, _}), do: true
  def double?(_), do: false

  def redouble?({:redouble, _}), do: true
  def redouble?(_), do: false

  def action?(bid) do
    pass?(bid) || double?(bid) || redouble?(bid)
  end
end
