defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  def main(args) do
    case Enum.at(args, 0) do
      nil -> IO.puts "Please provide an argument"
      s -> (case String.to_integer s do
              1 -> AdventOfCode.Day01ReportRepair.solve()
              _ -> IO.puts "That day is not supported"
            end)

    end
  end
end
