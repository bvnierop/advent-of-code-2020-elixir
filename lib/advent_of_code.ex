defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  @doc """
  Define some base functions that we want in all day solutions
  """
  defmacro __using__(_) do
    quote do
      import AdventOfCode

      def solve do
        time &solve_a/0, "Part 1"
        IO.puts ""
        time &solve_b/0, "Part 2"
      end
    end
  end

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

  def main(args) do
    case Enum.at(args, 0) do
      nil -> IO.puts "Please provide an argument"
      s -> (case String.to_integer s do
              1 -> AdventOfCode.Day01ReportRepair.solve()
              2 -> AdventOfCode.Day02PasswordPhilosophy.solve()
              _ -> IO.puts "That day is not supported"
            end)

    end
  end
end
