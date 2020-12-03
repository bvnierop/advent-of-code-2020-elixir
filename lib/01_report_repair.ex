defmodule AdventOfCode.Day01ReportRepair do
  use AdventOfCode

  def solve_a(input), do: solve_generic(input, 2)
  def solve_b(input), do: solve_generic(input, 3)

  def solve_generic(input, part_count) do
    parts = make_sum(input |> to_set, 2020, part_count)
    { parts, Enum.reduce(parts, &*/2) }
  end

  def make_sum(numbers, target_sum, to_use) when to_use == 1 do
    case MapSet.member?(numbers, target_sum) do
      false -> nil
      true -> [target_sum]
    end
  end

  def make_sum(numbers, target_sum, to_use) do
    Enum.find_value(numbers, fn n ->
      case make_sum(numbers, target_sum - n, to_use - 1) do
        nil -> nil
        res -> [n | res]
      end
    end)
  end

  def to_set(numbers) do
    numbers
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new
  end
end
