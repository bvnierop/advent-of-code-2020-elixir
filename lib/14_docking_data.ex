defmodule AdventOfCode.Day14DockingData do
  use AdventOfCode

  use Bitwise, only_operators: true

  defmodule Computer do
    def reduce(instructions) do
      {_mask, mem} = Enum.reduce(instructions, {{0, 0}, %{}}, fn
        {:mask, zeroes, ones}, {_mask, mem} -> {{zeroes, ones}, mem}
        {:mem, dst, val}, {mask, mem} -> {mask, Map.put(mem, dst, apply_mask(val, mask))}
      end)
      mem
    end

    def apply_mask(num, {zeroes, ones}), do: num &&& zeroes ||| ones
  end

  defmodule Parser do
    def parse(input) when is_list(input) do
      Enum.map(input, &parse/1)
    end

    def parse(input) when is_binary(input) do
      case input do
        "mask" <> _ ->
          [mask] = Regex.run(~r/mask = (.+)/, input, capture: :all_but_first)
          parse_mask(mask)
        "mem" <> _ ->
          [dst, val] = Regex.run(~r/mem\[(\d+)\] = (\d+)/, input, capture: :all_but_first) 
          {:mem, String.to_integer(dst), String.to_integer(val)}
      end
    end

    def parse_mask(mask) do
      {zeroes, ones} = String.graphemes(mask)
      |> Enum.reduce({0, 0}, fn val, {zeroes, ones} ->
        {(zeroes <<< 1) ||| (if val == "0", do: 0, else: 1), (ones <<< 1) ||| (if val == "1", do: 1, else: 0)}
      end)
      {:mask, zeroes, ones}
    end
  end

  def solve_a(input) do
    input
    |> Parser.parse
    |> Computer.reduce
    |> Map.values
    |> Enum.sum
  end

  def solve_b(input) do
    Enum.at(input, 0)
  end
end
