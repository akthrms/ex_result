defmodule ExResult do
  @moduledoc """
  Result/Either library inspired by Rust.
  """

  @type ok() :: {:ok, any()}

  @type error() :: {:error, any()}

  @type result() :: ok() | error()

  @spec ok(any()) :: result()
  @doc """
  Contains the success value.
  """
  def ok(value), do: {:ok, value}

  @spec error(any()) :: result()
  @doc """
  Contains the error value.
  """
  def error(value), do: {:error, value}

  @spec ok?(result()) :: boolean()
  @doc """
  Returns true if the result is ok.

  ## Examples

      iex> ExResult.ok(-3) |> ExResult.ok?()
      true

      iex> ExResult.error("Some error message") |> ExResult.ok?()
      false
  """
  def ok?({:ok, _}), do: true

  def ok?({:error, _}), do: false

  @spec error?(result()) :: boolean()
  @doc """
  Returns true if the result is error.

  ## Examples

      iex> ExResult.ok(-3) |> ExResult.error?()
      false

      iex> ExResult.error("Some error message") |> ExResult.error?()
      true
  """
  def error?({:ok, _}), do: false

  def error?({:error, _}), do: true

  @spec map(result(), (any() -> any())) :: result()
  @doc """
  Maps a result to another result by applying a function to a contained ok value, leaving an error value untouched.

  ## Examples

      iex> ExResult.ok(1) |> ExResult.map(fn x -> x * 2 end)
      {:ok, 2}
  """
  def map({:ok, value}, fun), do: ok(fun.(value))

  def map(result = {:error, _}, _), do: result

  @spec map_or(result(), any(), (any() -> any())) :: any()
  @doc """
  Applies a function to the contained value (if ok), or returns the provided default (if error).

  ## Examples

      iex> ExResult.ok("foo") |> ExResult.map_or(42, &String.length/1)
      3

      iex> ExResult.error("bar") |> ExResult.map_or(42, &String.length/1)
      42
  """
  def map_or({:ok, value}, _, fun), do: fun.(value)

  def map_or({:error, _}, default, _), do: default

  @spec map_or_else(result(), (any() -> any()), (any() -> any())) :: any()
  @doc """
  Maps a result to any by applying a function to a contained ok value, or a fallback function to a contained error value.

  ## Examples

      iex> ExResult.ok("foo")
      ...> |> ExResult.map_or_else(fn _ -> 21 * 2 end, fn x -> String.length(x) end)
      3

      iex> ExResult.error("bar")
      ...> |> ExResult.map_or_else(fn _ -> 21 * 2 end, fn x -> String.length(x) end)
      42
  """
  def map_or_else({:ok, value}, _, fun), do: fun.(value)

  def map_or_else({:error, value}, default, _), do: default.(value)
end
