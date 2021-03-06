defmodule AdventOfCode.Day02PasswordPhilosophy do
  use AdventOfCode
  
  def solve_a(input) do
    input
    |> parse
    |> Enum.count(&valid_a/1)
  end

  def solve_b(input) do
    input
    |> parse
    |> Enum.count(&valid_b/1)
  end

  def valid_a({lo, hi, chr, password}) do
    count = password
    |> String.graphemes
    |> Enum.count(&(chr == &1))

    count in lo..hi
  end

  def valid_b({a, b, chr, password}) do
    chr_a = String.at(password, a - 1)
    chr_b = String.at(password, b - 1)

    chr_a != chr_b && chr in [chr_a, chr_b]
  end

  def parse(lines) do
    re = ~r/(\d+)-(\d+) (\w): (\w+)/
    lines
    |> Enum.map(fn line ->
      [lo, hi, chr, password] = Regex.run(re, line, capture: :all_but_first)
      { String.to_integer(lo), String.to_integer(hi), chr, password }
    end)
  end
end
