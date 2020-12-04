defmodule AdventOfCode.Day03TobogganTrajectory do
  use AdventOfCode

  defp solve_a(input), do: solve_for_slope(3, 1, process(input))
  defp process(input), do: Enum.to_list(input) |> List.to_tuple

  defp solve_for_slope(dx, dy, map) do
    height = tuple_size(map)
    Stream.iterate(0, &(&1 + 1))
    |> Enum.take_while(fn step -> step * dy < height end)
    |> Enum.count(fn step -> tree?(step * dx, step * dy, map) end)
  end

  defp tree?(x, y, map) do
    width = elem(map, 0) |> String.length
    adjusted_x = rem(x, width)
    String.at(elem(map, y), adjusted_x) == "#"
  end

  defp solve_b(input) do
    processed = process(input)
    _slopes = [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {dx, dy} -> solve_for_slope(dx, dy, processed) end)
    |> Enum.reduce(&*/2)
  end
end
