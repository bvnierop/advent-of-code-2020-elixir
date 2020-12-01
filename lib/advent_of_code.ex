defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  def main(args) do
    if length(args) != 0 do
      AdventOfCode.Day01ReportRepair.solve()
    else
      IO.puts "Please provide an argument"
    end
  end
end
