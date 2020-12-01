defmodule AdventOfCode.Day01ReportRepair do
  @moduledoc """
  Documentation for `Day 01`.
  """

  @doc """
  Run it
  """
  def solve do
    solve_a()
    solve_b()
  end

  def solve_a do
    numbers = input() |> Enum.map(&String.to_integer/1)
    pairs = for x <- numbers, y <- numbers, x + y == 2020, do: x * y
    IO.inspect pairs
  end

  def solve_b do
    numbers = input() |> Enum.map(&String.to_integer/1)
    pairs = for x <- numbers, y <- numbers, z <- numbers, x + y + z == 2020, do: x * y * z
    IO.inspect pairs
  end

  def input do
    # ["1721", "979", "366", "299", "675", "1456"]
    File.stream!("input/01_report_repair.in")
    |> Stream.map(&String.trim/1)
  end
end
