defmodule DomHelpersTest do
  use ExUnit.Case
  doctest DomHelpers

  test "greets the world" do
    assert DomHelpers.hello() == :world
  end
end
