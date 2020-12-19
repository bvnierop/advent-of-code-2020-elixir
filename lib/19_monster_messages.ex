defmodule AdventOfCode.Day19MonsterMessages do
  use AdventOfCode

  defmodule RuleEngine do
    def parse(rules) when is_list(rules) do
      rules
      |> Enum.map(&parse/1)
      |> Map.new
    end

    def parse(rule) when is_binary(rule) do
      [id, match] = Regex.run(~r/(\d+): (.+)$/, rule, capture: :all_but_first)
      {String.to_integer(id), parse_match(match)}
    end

    defp parse_match("\"" <> chr), do: String.at(chr, 0)
    defp parse_match(int_list) do
      int_list
      |> String.split("|")
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(&Enum.map(&1, fn id -> String.to_integer(id) end))
    end

    def match?(rulebook, input) do
      find(rulebook, input)
    end

    def reduce(id, book, options, find) do
      options = options |> filter(find)

      if MapSet.size(options) == 0 do
        options
      else
        case book[id] do
          chr when is_binary(chr) ->
            Enum.map(options, fn str -> str <> chr end) |> MapSet.new

          alts when is_list(alts) ->
            Enum.reduce(alts, MapSet.new, fn seq, res ->
              MapSet.union(res,(Enum.reduce(seq, options, fn id, opts ->
                        reduce(id, book, opts, find)
                      end)) |> MapSet.new)
            end)
        end |> filter(find)
      end
    end

    def filter(options, find) do
      Enum.filter(options, &String.starts_with?(find, &1))
      |> MapSet.new
    end

    def find(book, what) do
      found = reduce(0, book, MapSet.new([""]), what)
      MapSet.member?(found, what)
    end
  end

  def parse(input) do
    [rules, _, lines] = Enum.chunk_by(input, &(&1 == ""))
    {RuleEngine.parse(rules), lines}
  end

  def solve_a(input) do
    {rulebook, lines} = parse(input)
    lines
    |> Enum.filter(&RuleEngine.match?(rulebook, &1))
    |> Enum.count
  end

  def patch_rulebook(rulebook) do
    rulebook
    |> Map.put(8, [[42], [42, 8]])
    |> Map.put(11, [[42, 31], [42, 11, 31]])
  end

  def solve_b(input) do
    {rulebook, lines} = parse(input)
    patched_book = patch_rulebook(rulebook)
    lines
    |> Enum.filter(&RuleEngine.match?(patched_book, &1))
    |> Enum.count
  end
end
