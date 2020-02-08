defmodule Kibitzing.Engine.Convention.Result do
  @doc ~S"""
  Converts a boolean to :ok or :next

  ## Examples

      iex> Kibitzing.Engine.Convention.Result.opt(true)
      :ok

      iex> Kibitzing.Engine.Convention.Result.opt(false)
      :next

  """
  def opt(val), do: optional(val)
  def optional(true), do: :ok
  def optional(false), do: :next

  @doc ~S"""
  Converts a boolean to :next or :fail

  ## Examples

      iex> Kibitzing.Engine.Convention.Result.skip(true)
      :next

      iex> Kibitzing.Engine.Convention.Result.skip(false)
      :fail

  """
  def skip(true), do: :next
  def skip(false), do: :fail

  @doc ~S"""
  Converts a boolean to :ok or :fail

  ## Examples

      iex> Kibitzing.Engine.Convention.Result.req(true)
      :ok

      iex> Kibitzing.Engine.Convention.Result.req(false)
      :fail

  """
  def req(val), do: required(val)
  def required(true), do: :ok
  def required(false), do: :fail
end
