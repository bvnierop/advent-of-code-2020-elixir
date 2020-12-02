defmodule AdventOfCode.Day01ReportRepair do
  use AdventOfCode

  def solve_a do
    {a, b } = find_sum(input() |> to_set, 2020)
    {a, b, a * b}
  end

  def find_sum(numbers, sum) do
    numbers
    |> Enum.find(&MapSet.member?(numbers, sum - &1))
    |> case do
         nil -> nil
         number -> { number, sum - number }
       end
  end

  def solve_b do
    numbers = input() |> to_set
    a = Enum.find(numbers, &find_sum(numbers, 2020 - &1))
    {b, c} = find_sum(numbers, 2020 - a)
    {a, b, c, a * b * c}
  end

  def to_set(numbers) do
    numbers
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new
  end

  def input do
    # ["1721", "979", "366", "299", "675", "1456"]
    File.stream!("input/01_report_repair.in")
    |> Stream.map(&String.trim/1)
  end
end
