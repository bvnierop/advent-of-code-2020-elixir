defmodule AdventOfCode.Day07HandyHaversacks do
  use AdventOfCode

  def solve_a(input) do
    input |> parse |> find_bags_containing("shiny gold") |> MapSet.size
  end

  def solve_b(input) do
    input
    |> parse
    |> invert
    |> count_required_bags("shiny gold")
    |> (&(&1 - 1)).()
  end

  def parse(line) when is_binary(line) do
    if Regex.match?(~r/^(.+?) bags contain no other bags.$/, line) do
      {:none}
    else
      [bag] = Regex.run(~r/^(.+?) bags contain/, line, capture: :all_but_first)
      {:some,
       line
       |> String.replace(bag <> " bags contain ", "")
       |> String.split(",")
       |> Enum.map(fn part -> Regex.run(~r/(\d+) (.+?) bags?/, part, capture: :all_but_first) end)
       |> Enum.map(fn [amount, contains] -> {contains, %{bag => String.to_integer(amount)}} end)}
    end
  end

  def parse(lines) do
    Enum.reduce(lines, %{}, fn line, acc ->
      case parse(line) do
        {:none} -> acc
        {:some, bags} ->
          Enum.reduce(bags, acc, fn {bag, contained_by}, acc ->
            Map.put(acc, bag, Map.merge(acc[bag] || %{}, contained_by)) end)
      end
    end)
  end

  def find_bags_containing(graph, bag) do
    parents = Map.keys(graph[bag] || %{})
    Enum.reduce(parents, MapSet.new(parents), fn parent, acc ->
      MapSet.union(acc, find_bags_containing(graph, parent))
    end)
  end

  def invert(graph) do
    Enum.reduce(graph, %{}, fn {bag, contained_by}, inverted_graph ->
      Enum.reduce(contained_by, inverted_graph, fn {containing_bag, count}, inverted_graph ->
        Map.put(inverted_graph, containing_bag,
          Map.put(inverted_graph[containing_bag] || %{}, bag, count))
        end)
      end)
  end

  def count_required_bags(graph, bag) do
    case graph[bag] do
      nil -> 1
      contained_bags ->
        Enum.reduce(contained_bags, 1, fn {contained_bag, count}, total ->
          total + count_required_bags(graph, contained_bag) * count
        end)
    end
  end
end
