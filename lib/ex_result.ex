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
end
