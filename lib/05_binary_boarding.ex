defmodule AdventOfCode.Day05BinaryBoarding do
  use AdventOfCode
  use Bitwise, only_operators: true

  def solve_a(input) do
    input
    |> Enum.map(&parse_seat/1)
    |> Enum.max_by(fn {_, _, code} -> code end)
  end

  def solve_b(input) do
    input
    |> Enum.map(&make_code/1)
    |> Enum.sort
    |> Enum.reduce_while(nil, fn elt, state ->
      case state do
        nil -> {:cont, elt}
        prev -> if elt - prev == 2, do: {:halt, elt - 1}, else: {:cont, elt}
      end
    end)
    |> make_seat
  end

  def parse_seat(input), do: input |> make_code |> make_seat
  defp make_seat(code), do: { row(code), column(code), code }
  defp row(code), do: code >>> 3
  defp column(code), do: code &&& 0b111

  defp make_code(input) do
    {code, _} = input
    |> String.replace("F", "0") |> String.replace("B", "1")
    |> String.replace("L", "0") |> String.replace("R", "1")
    |> fn s -> "0b" <> s end.()
    |> Code.eval_string

    code
  end
end
