defmodule AdventOfCode.Day09EncodingError do
  use AdventOfCode

  def solve_a(input) do
    input
    |> parse
    |> first_invalid(25)
  end

  def solve_b(input) do
    sequence = input |> parse
    target = first_invalid(sequence, 25)
    find_sequence(sequence, target)
    |> make_result
  end

  def parse(input) do
    input
    |> Enum.map(&String.to_integer/1)
  end

  def valid?(sequence) do
    target = Enum.take(sequence, -1) |> Enum.at(0)
    seq = Enum.drop(sequence, -1) |> List.to_tuple
    len = tuple_size(seq) - 1

    Enum.count(for x <- 0..len, y <- x..len,
      a = elem(seq, x),
      b = elem(seq, y),
      a != b, a + b == target, do: a + b) > 0
  end

  def first_invalid(sequence, preamble) do
    sequence
    |> Enum.chunk_every(preamble + 1, 1, :discard)
    |> Enum.find(&(valid?(&1) == false))
    |> Enum.take(-1)
    |> Enum.at(0)
  end

  def find_sequence(sequence, num) do
    2..Enum.count(sequence)
    |> Enum.find_value(fn chunk_size ->
      Stream.chunk_every(sequence, chunk_size, 1, :discard)
      |> Enum.find(fn chunk -> Enum.sum(chunk) == num end)
    end)
  end

  def make_result(seq) do
    lo = Enum.min(seq)
    hi = Enum.max(seq)
    { lo, hi, lo + hi }
  end
end
