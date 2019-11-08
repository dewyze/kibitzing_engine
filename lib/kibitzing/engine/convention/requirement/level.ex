defmodule Kibitzing.Engine.Convention.Requirement.Level do
  alias Kibitzing.Engine.Models.Table

  def one, do: &one/1
  def one(%Table{bid: {_, _}}), do: :next
  def one(%Table{bid: {level, _, _}}) when level == :one, do: :ok
  def one(_), do: :fail

  def two, do: &two/1
  def two(%Table{bid: {_, _}}), do: :next
  def two(%Table{bid: {level, _, _}}) when level == :two, do: :ok
  def two(%Table{bid: {level, _, _}}) when level in [:one], do: :next
  def two(_), do: :fail

  def three, do: &three/1
  def three(%Table{bid: {_, _}}), do: :next
  def three(%Table{bid: {level, _, _}}) when level == :three, do: :ok
  def three(%Table{bid: {level, _, _}}) when level in [:one, :two], do: :next
  def three(_), do: :fail

  def four, do: &four/1
  def four(%Table{bid: {_, _}}), do: :next
  def four(%Table{bid: {level, _, _}}) when level == :four, do: :ok
  def four(%Table{bid: {level, _, _}}) when level in [:one, :two, :three], do: :next
  def four(_), do: :fail

  def five, do: &five/1
  def five(%Table{bid: {_, _}}), do: :next
  def five(%Table{bid: {level, _, _}}) when level == :five, do: :ok
  def five(%Table{bid: {level, _, _}}) when level in [:one, :two, :three, :four], do: :next
  def five(_), do: :fail

  def six, do: &six/1
  def six(%Table{bid: {_, _}}), do: :next
  def six(%Table{bid: {level, _, _}}) when level == :six, do: :ok
  def six(%Table{bid: {level, _, _}}) when level in [:one, :two, :three, :four, :five], do: :next
  def six(_), do: :fail

  def seven, do: &seven/1
  def seven(%Table{bid: {level, _, _}}) when level == :seven, do: :ok
  def seven(_), do: :next
end
