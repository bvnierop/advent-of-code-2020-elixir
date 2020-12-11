defmodule AdventOfCode.Day11SeatingSystemTest do
  use ExUnit.Case
  doctest AdventOfCode.Day11SeatingSystem

  # import AdventOfCode.Day11SeatingSystem

  alias AdventOfCode.Day11SeatingSystem.Layout, as: Layout
  alias AdventOfCode.Day11SeatingSystem.Simulation, as: Simulation

  test "parse layout" do
    assert Layout.parse([".L", "L."]) == %{{1, 0} => "L", {0, 1} => "L", {0, 0} => ".", {1, 1} => "."}
  end

  # rules
  # No adjacent seats taken: occupy
  # >= 4 adjacent seats taken: vacate
  def make_layout(str), do: str |> String.trim |> String.split("\n") |> Layout.parse

  test "occupy seats with no adjacent seats taken" do
    layout = make_layout("""
    LLL
    LLL
    LLL
    """)

    result = make_layout("""
    ###
    ###
    ###
    """)

    assert Simulation.step(layout) == result
  end

  test "free seats with four or more adjacent seats taken" do
    layout = make_layout("""
    .LLL.
    LL#LL
    L###L
    L#LLL
    LLL..
    """)

    result = make_layout("""
    .LLL.
    LL#LL
    L#L#L
    L#LLL
    LLL..
    """)

    assert Simulation.step(layout) == result
  end

  test "find neighbours" do
    layout = make_layout("""
    ....
    LL.#
    ....
    ...L
    """)

    neighbours = [{0, 1}, {3, 1}, {3, 3}]
    assert Layout.find_neighbours(layout, 1, 1, ["L", "#"]) == neighbours
  end
end
