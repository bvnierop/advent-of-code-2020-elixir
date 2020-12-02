defmodule AdventOfCode.Day02PasswordPhilosophy do
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

  @doc """
  Run it
  """
  def solve do
    time &solve_a/0, "Part 1"
    IO.puts ""
    time &solve_b/0, "Part 2"
  end

  def solve_a do
    input()
    |> Enum.filter(&valid_a/1)
    |> Enum.count
  end

  def solve_b do
    input()
    |> Enum.filter(&valid_b/1)
    |> Enum.count
  end

  def valid_a(password) do
    min = String.to_integer(password["min"])
    max = String.to_integer(password["max"])
    count = count_characters(password["password"])[password["chr"]] || 0
    count >= min && count <= max
  end

  def count_characters(password) do
    password
    |> String.graphemes
    |> Enum.reduce(%{}, fn chr, acc ->
      Map.put acc, chr, (acc[chr] || 0) + 1
      end)
  end

  def valid_b(password) do
    passphrase = password["password"]
    chra = String.at(passphrase, String.to_integer(password["min"]) - 1)
    chrb = String.at(passphrase, String.to_integer(password["max"]) - 1)
    expected = password["chr"]
    (chra == expected || chrb == expected) && chra != chrb
  end

  def input do
    re = ~r/(?<min>\d+)-(?<max>\d+) (?<chr>\w): (?<password>\w+)/
    lines()
    |> Enum.map(&Regex.named_captures(re, &1))
  end

  def lines do
    # ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
    File.stream!("input/02_password_philosophy.in")
    |> Stream.map(&String.trim/1)
  end
end
