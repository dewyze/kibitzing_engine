defmodule Kibitzing.Engine.Models.Table do
  defstruct previous_bids: [],
            bid: nil,
            next_bids: [],
            labeled_bids: Keyword.new()

  alias Kibitzing.Engine.Models.Bid

  def validate(%__MODULE__{next_bids: bids} = table) do
    if _valid?(bids) && _validate_doubles?(bids) do
      {:ok, table}
    else
      {:fail}
    end
  end

  defp _valid?([]), do: true
  defp _valid?([_ | []]), do: true

  defp _valid?([bid | [next | _] = bids]) do
    cond do
      Bid.action?(bid) ||
        Bid.action?(next) ||
          Bid.higher?(next, bid) ->
        _valid?(bids)

      true ->
        false
    end
  end

  defp _validate_doubles?([]), do: true
  defp _validate_doubles?([_ | []]), do: true
  defp _validate_doubles?([{:double, _} | [{:double, _} | _]]), do: false
  defp _validate_doubles?([{:redouble, _} | [{:double, _} | _]]), do: false
  defp _validate_doubles?([{:redouble, _} | [{:redouble, _} | _]]), do: false
  defp _validate_doubles?([{:double, _} | [{:pass, _} | [{:double, _} | _]]]), do: false
  defp _validate_doubles?([{:redouble, _} | [{:pass, _} | [{:double, _} | _]]]), do: false
  defp _validate_doubles?([{:double, _} | [{:pass, _} | [{:redouble, _} | _]]]), do: false
  defp _validate_doubles?([{:redouble, _} | [{:pass, _} | [{:redouble, _} | _]]]), do: false
  defp _validate_doubles?([{_, _, _} | [{:pass, _} | [{:double, _} | _]]]), do: false
  defp _validate_doubles?([{_, _, _} | [{:pass, _} | [{:redouble, _} | _]]]), do: false

  defp _validate_doubles?([_ | bids]) do
    _validate_doubles?(bids)
  end
end
