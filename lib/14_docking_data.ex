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

    def reduce_b(instructions) do
      {_mask, mem} = Enum.reduce(instructions, {"", %{}}, fn
        {:mask, mask}, {_mask, mem} -> {mask, mem}
        {:mem, dst, val}, {str_mask, mem} ->
          masked_dst = apply_mask2(dst, str_mask)
          new_mem = stream(masked_dst)
          |> Enum.reduce(mem, fn dst, mem ->
            Map.put(mem, dst, val)
          end)
          {str_mask, new_mem}
      end)
      mem
    end

    def apply_mask2(num, mask) do
      num_str = Integer.to_string(num, 2)
      |> String.pad_leading(String.length(mask), "0")

      for n <- 0..(String.length(mask) - 1),
        v = String.at(num_str, n),
        m = String.at(mask, n),
        into: "",
        do: (if m == "0", do: v, else: m)
    end

    def next(mask), do: String.replace(mask, "X", "0") |> String.to_integer(2)
    def next(mask, cur), do: next(mask, String.length(mask) - 1, cur)
    def next("X"<>_rest, 0, 0), do: 1
    def next("X"<>_rest, 0, 1), do: nil
    def next(_mask, 0, _), do: nil
    def next(mask, n, cur) do
      case String.at(mask, n) do
        "X" -> case cur &&& 1 do
                 0 -> cur ||| 1
                 1 -> case next(mask, n - 1, cur >>> 1) do
                        nil -> nil
                        n -> n <<< 1
                      end
               end
        _ -> case next(mask, n - 1, cur >>> 1) do
               nil -> nil
               n -> (n <<< 1) ||| (cur &&& 1)
             end
      end
    end

    def stream(mask) do
      Stream.unfold({mask, next(mask)}, fn
        {_, nil} -> nil
        {mask, cur}  -> {cur, {mask, next(mask, cur)}}
      end)
    end
  end

  defmodule Parser do
    def parse(input, must_parse_mask \\ true)
    def parse(input, must_parse_mask) when is_list(input), do: Enum.map(input, &parse(&1, must_parse_mask))
    def parse(input, must_parse_mask) when is_binary(input) do
      case input do
        "mask" <> _ ->
          [mask] = Regex.run(~r/mask = (.+)/, input, capture: :all_but_first)
          if must_parse_mask, do: parse_mask(mask), else: {:mask, mask}
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
    input
    |> Parser.parse(false)
    |> Computer.reduce_b
    |> Map.values
    |> Enum.sum
  end
end
