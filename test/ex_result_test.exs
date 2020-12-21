defmodule ExResultTest do
  use ExUnit.Case
  doctest ExResult

  test "greets the world" do
    assert ExResult.hello() == :world
  end
end
