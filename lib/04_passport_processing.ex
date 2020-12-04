defmodule AdventOfCode.Day04PassportProcessing do
  use AdventOfCode

  def validations do
    [
      [:byr, ~r/^(\d{4})$/, fn [yr] -> String.to_integer(yr) in 1920..2002 end],
      [:iyr, ~r/^(\d{4})$/, fn [yr] -> String.to_integer(yr) in 2010..2020 end],
      [:eyr, ~r/^(\d{4})$/, fn [yr] -> String.to_integer(yr) in 2020..2030 end],
      [:hgt, ~r/^(\d+)(cm|in)$/, fn [height, unit] ->
        case unit do
          "cm" -> String.to_integer(height) in 150..193
          "in" -> String.to_integer(height) in 59..76
          _ -> false
        end
      end],
      [:hcl, ~r/^\#([0-9a-f]{6})$/, fn _ -> true end],
      [:ecl, ~r/^(\w+)$/, fn [ecl] -> ecl in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] end],
      [:pid, ~r/^(\d{9})$/, fn _ -> true end]
    ]
  end

  defp solve_a(input), do: input |> process |> Enum.count(&(valid?(&1, false)))
  defp solve_b(input), do: input |> process |> Enum.count(&(valid?(&1, true)))

  def process(input) do
    {acc, cur} = Enum.reduce(input, {[], []}, fn line, {acc, cur} ->
      case line do
        "" -> { [cur | acc], [] }
        l -> { acc, [l | cur] }
      end
    end)
    [ cur | acc ]
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.map(&convert/1)
    |> Enum.reverse
  end

  def convert(card_as_string) do
    card_as_string
    |> String.split(~r/\s|:/) # Split on both space and colon
    |> Enum.chunk_every(2)
    |> Map.new(fn [k, v] -> {String.to_atom(k), v} end)
  end

  def valid?(card, strict) do
    validations()
    |> Enum.all?(&valid_key?(card, &1, skip_data_validation: !strict))
  end

  def valid_key?(card, [key, regex, vald], skip_data_validation: skip_data_validation) do
    case { Map.has_key?(card, key),
           Regex.run(regex, card[key] || "", capture: :all_but_first) } do
      { false, _ } -> false
      { true, nil } -> skip_data_validation
      { true, match } -> skip_data_validation || vald.(match)
    end
  end
end
