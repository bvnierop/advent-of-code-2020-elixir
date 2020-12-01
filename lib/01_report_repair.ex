defmodule AdventOfCode.Day01ReportRepair do
  @moduledoc """
  Documentation for `Day 01`.
  """

  @doc """
  Time a function and print its result"
  """
  def time(f, label) do
    case :timer.tc f do
      {time, result} ->
        IO.inspect result, label: label
        IO.puts "Runtime: #{:erlang.float_to_binary(time / 1_000, [decimals: 2])} ms."
    end

  end

  @doc """
  Run it
  """
  def solve do
    time &solve_a/0, "Part 1"
    IO.puts ""
    time &solve_b/0, "Part 2"
  end

  def solve_a do
    numbers = input() |> Enum.map(&String.to_integer/1)
    pairs = for x <- numbers, y <- numbers, x + y == 2020, do: x * y
    Enum.at(pairs, 0)
  end

  def solve_b do
    numbers = input() |> Enum.map(&String.to_integer/1)
    pairs = for x <- numbers, y <- numbers, z <- numbers, x + y + z == 2020, do: x * y * z
    Enum.at(pairs, 0)
  end

  def input do
    # ["1721", "979", "366", "299", "675", "1456"]
    File.stream!("input/01_report_repair.in")
    |> Stream.map(&String.trim/1)
  end
end
