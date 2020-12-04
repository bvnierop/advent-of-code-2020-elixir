defmodule AdventOfCode.Day04PassportProcessing do
  use AdventOfCode

  @required_fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]

  defp solve_a(input), do: input |> process |> Enum.count(&(valid?(&1, false)))
  defp solve_b(input), do: input |> process |> Enum.count(&(valid?(&1, true)))

  def process(input) do
    input
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.reject(&(&1 == ""))
    |> Enum.map(&convert/1)
  end

  def convert(card_as_string) do
    card_as_string
    |> String.split(~r/\s|:/) # Split on both space and colon
    |> Enum.chunk_every(2)
    |> Map.new(fn [k, v] -> {String.to_atom(k), v} end)
  end

  def valid?(card, strict) do
    @required_fields -- Map.keys(card) == [] &&
      Enum.all?(card, fn {key, value} -> valid_key?(key, value, strict) end)
  end

  def valid_key?(_key, value, false), do: value != nil
  def valid_key?(key, value, true), do: valid_key?(key, value)

  def valid_key?(key, value) when key in [:byr, :iyr, :eyr] and is_binary(value),
    do: valid_key?(key, String.to_integer(value))

  def valid_key?(:byr, yr), do: yr in 1920..2002
  def valid_key?(:iyr, yr), do: yr in 2010..2020
  def valid_key?(:eyr, yr), do: yr in 2020..2030

  def valid_key?(:hgt, hgt) when is_binary(hgt),
    do: valid_key?(:hgt, Integer.parse(hgt))

  def valid_key?(:hgt, {hgt, "cm"}), do: hgt in 150..193
  def valid_key?(:hgt, {hgt, "in"}), do: hgt in 59..76

  def valid_key?(:hcl, hcl), do: Regex.match?(~r/^\#([0-9a-f]{6})$/, hcl)

  def valid_key?(:ecl, ecl), do: ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  def valid_key?(:pid, pid), do: Regex.match?(~r/^(\d{9})$/, pid)
  def valid_key?(:cid, _), do: true

  def valid_key?(_, _), do: false
end
