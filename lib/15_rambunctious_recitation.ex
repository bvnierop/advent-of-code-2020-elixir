defmodule AdventOfCode.Day15RambunctiousRecitation do
  use AdventOfCode

  def solve_a(input) do
    input
    |> parse
    |> stream
    |> Enum.at(2019) # 2020 - 1 because zero-indexed
  end

  def solve_b(input) do
    input
    |> parse
    |> stream
    |> Enum.at(30000000 - 1)
  end

  def parse([input]), do: input |> String.split(",") |> Enum.map(&String.to_integer/1)

  def stream(starting_numbers) do
    Stream.unfold({starting_numbers, {0, nil}, %{}}, fn
      {[num | rest], {last_turn, last_choice}, history} -> {num, {rest, {last_turn + 1, num}, Map.put(history, last_choice, last_turn)}}
      {[], turn, history}                                  -> step(turn, history)
    end)
  end

  def step({last_turn, last_choice}, history) do
    value = case history[last_choice] do
              nil -> 0 # Not said before
              n   -> last_turn - n
            end

    {value, {[], {last_turn + 1, value}, Map.put(history, last_choice, last_turn)}}
  end
end
