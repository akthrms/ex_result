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

  @spec map_error(result(), (any() -> any())) :: result()
  @doc """
  Maps a result to another result by applying a function to a contained error value, leaving an ok value untouched.

  ## Examples

      iex> ExResult.ok(2)
      ...> |> ExResult.map_error(fn x -> "error code: \#{x}" end)
      {:ok, 2}

      iex> ExResult.error(13)
      ...> |> ExResult.map_error(fn x -> "error code: \#{x}" end)
      {:error, "error code: 13"}
  """
  def map_error(result = {:ok, _}, _), do: result

  def map_error({:error, value}, fun), do: error(fun.(value))

  @spec result_and(result(), result()) :: result()
  @doc """
  Returns result2 if the result is Ok, otherwise returns the error value of result1.

  ## Examples

      iex> ExResult.result_and(ExResult.ok(2), ExResult.error("late error"))
      {:error, "late error"}

      iex> ExResult.result_and(ExResult.error("early error"), ExResult.ok("foo"))
      {:error, "early error"}

      iex> ExResult.result_and(ExResult.error("not a 2"), ExResult.error("late error"))
      {:error, "not a 2"}

      iex> ExResult.result_and(ExResult.ok(2), ExResult.ok("different result type"))
      {:ok, "different result type"}
  """
  def result_and({:ok, _}, result2 = {:ok, _}), do: result2

  def result_and({:ok, _}, result2 = {:error, _}), do: result2

  def result_and(result1 = {:error, _}, {:ok, _}), do: result1

  def result_and(result1 = {:error, _}, {:error, _}), do: result1
end
