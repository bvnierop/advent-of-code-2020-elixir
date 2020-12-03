defmodule AdventOfCode.Day03TobogganTrajectory do
  use AdventOfCode

  def tree?(x, y, map) do
    width = elem(map, 0) |> String.length
    adjusted_x = rem(x, width)
    String.at(elem(map, y), adjusted_x) == "#"
  end

  def solve_for_slope(dx, dy, input) do
    height = tuple_size(input)
    Stream.iterate(0, &(&1 + 1))
    |> Enum.take_while(fn step -> step * dy < height end)
    |> Enum.count(fn step -> tree?(step * dx, step * dy, input) end)
  end

  def solve_a(input) do
    tuple = Enum.to_list(input) |> List.to_tuple
    solve_for_slope(3, 1, tuple)
  end

  def solve_b(input) do
    tuple = Enum.to_list(input) |> List.to_tuple
    slopes = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]
    slopes
    |> Enum.map(fn {dx, dy} -> solve_for_slope(dx, dy, tuple) end)
    |> Enum.reduce(&*/2)
  end
end
