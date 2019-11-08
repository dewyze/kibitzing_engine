defmodule Kibitzing.Engine.Convention.Requirement.Strain do
  alias Kibitzing.Engine.Models.{Strain, Table}
  alias Kibitzing.Engine.Convention.Result

  def no_trump, do: &no_trump/1
  def no_trump(table), do: Result.opt(match?(%Table{bid: {_, :no_trump, _}}, table))

  def spades, do: &spades/1
  def spades(%Table{bid: bid}), do: Result.opt(match?({_, :spades, _}, bid))

  def hearts, do: &hearts/1
  def hearts(%Table{bid: bid}), do: Result.opt(match?({_, :hearts, _}, bid))

  def diamonds, do: &diamonds/1
  def diamonds(%Table{bid: bid}), do: Result.opt(match?({_, :diamonds, _}, bid))

  def clubs, do: &clubs/1
  def clubs(%Table{bid: bid}), do: Result.opt(match?({_, :clubs, _}, bid))

  def major, do: &major/1
  def major(%Table{bid: {_, strain, _}}), do: Result.opt(Enum.member?(Strain.majors(), strain))
  def major(_), do: :next

  def minor, do: &minor/1
  def minor(%Table{bid: {_, strain, _}}), do: Result.opt(Enum.member?(Strain.minors(), strain))
  def minor(_), do: :next

  def suit, do: &suit/1
  def suit(%Table{bid: {_, strain, _}}), do: Result.opt(Enum.member?(Strain.suits(), strain))
  def suit(_), do: :next

  def new_strain, do: &new_strain/1
  def new_strain(%Table{bid: {_, _}}), do: :next

  def new_strain(%Table{previous_bids: previous_bids, bid: {_, strain, _}}) do
    Result.opt(
      Enum.all?(previous_bids, fn bid ->
        with {_, prev_strain, _} <- bid do
          strain != prev_strain
        else
          _ -> true
        end
      end)
    )
  end

  def eq(func), do: equal_to(func)
  def equal_to(func), do: fn table -> equal_to(func, table) end

  def equal_to(func, table) do
    with {:ok, {_, other_strain, _}} <- func.(table),
         {_, strain, _} <- table.bid do
      Result.opt(other_strain == strain)
    else
      _ ->
        :next
    end
  end

  def lt(func), do: lower_than(func)
  def lower_than(func), do: fn table -> lower_than(func, table) end

  def lower_than(func, table) do
    with {:ok, {_, other_strain, _}} <- func.(table),
         {_, strain, _} <- table.bid do
      result =
        Enum.find_index(Strain.all(), fn s -> s == other_strain end) >
          Enum.find_index(Strain.all(), fn s -> s == strain end)

      Result.opt(result)
    else
      _ ->
        :next
    end
  end

  def ht(func), do: higher_than(func)
  def higher_than(func), do: fn table -> higher_than(func, table) end

  def higher_than(func, table) do
    with {:ok, {_, other_strain, _}} <- func.(table),
         {_, strain, _} <- table.bid do
      result =
        Enum.find_index(Strain.all(), fn s -> s == strain end) >
          Enum.find_index(Strain.all(), fn s -> s == other_strain end)

      Result.opt(result)
    else
      _ ->
        :next
    end
  end
end
