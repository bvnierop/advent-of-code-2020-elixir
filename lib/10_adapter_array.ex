defmodule AdventOfCode.Day10AdapterArray do
  use AdventOfCode

  def solve_a(input) do
    counts = input
    |> parse
    |> Enum.concat([0])
    |> Enum.sort
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(%{3 => 1}, fn [a, b], acc ->
      Map.put(acc, abs(a - b), (acc[abs(a - b)] || 0) + 1)
    end)
	{counts, counts[1] * counts[3]}
  end

  def solve_b(input) do
    input
    |> parse
    |> Enum.sort
    |> Enum.reduce(%{0 => 1}, fn cur, acc ->
      ways = [1, 2, 3]
      |> Enum.map(fn offset -> get(acc, cur - offset) end)
      |> Enum.sum
      Map.put(acc, cur, ways)
    end)
    |> Enum.max
  end

  def get(map, key), do: map[key] || 0

  def parse(input) do
    input |> Enum.map(&String.to_integer/1)
  end
end
