defmodule AdventOfCode.Day03TobogganTrajectory do
  use AdventOfCode

  defp solve_a(input), do: solve_for_slope(3, 1, input)

  defp solve_for_slope(dx, dy, map) do
    map
    |> Stream.take_every(dy)
    |> Stream.with_index
    |> Enum.count(fn {row, index} -> tree?(row, index * dx) end)
  end

  defp tree?(row, x), do: String.at(row, rem(x, String.length(row))) == "#"

  defp solve_b(input) do
    _slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {dx, dy} -> solve_for_slope(dx, dy, input) end)
    |> Enum.reduce(&*/2)
  end
end
