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

      def solve(input_file) do
        input = lines(input_file)
        time (fn -> solve_a(input) end), "Part 1"
        IO.puts ""
        time (fn -> solve_b(input) end), "Part 2"
      end

      def lines(input_file) do
        File.stream!(Path.join(["input", input_file]))
        |> Stream.map(&String.trim/1)
        |> Stream.reject(&is_nil/1)
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

  def get_solutions do
    :code.all_available()
    |> Enum.map(fn {m, _, _} -> to_string(m) end)
    |> Enum.filter(&String.match?(&1, ~r/AdventOfCode\.Day\d\d\w+/))
    |> Enum.reduce(%{}, fn elt, acc ->
      [day] = Regex.run(~r/(\d\d)/, elt, capture: :all_but_first)
      Map.put(acc, String.to_integer(day), String.to_existing_atom(elt)) end)
  end

  def filebase_from_module(module) do
    module
    |> to_string
    |> String.split(".")
    |> Enum.at(2)
    |> Macro.underscore
    |> String.replace(~r/^day(\d+\w+)/, "\\1")
  end

  def filename(module, suffix) when suffix == nil do
    filebase_from_module(module) <> ".in"
  end

  def filename(module, suffix) when suffix != nil do
    filebase_from_module(module) <> "_" <> suffix <> ".in"
  end

  def main(args) do
    solutions = get_solutions()
    case solutions[String.to_integer(Enum.at(args, 0) || "0")] do
      nil -> IO.puts "Please provide an argument"
      mod -> apply(mod, :solve, [filename(mod, Enum.at(args, 1))])
    end
  end
end
