defmodule AdventOfCode.Day07HandyHaversacks do
  use AdventOfCode

  def solve_a(input) do
    input
    |> parse
    |> invert
    |> find_bags_containing("shiny gold")
    |> MapSet.size
  end

  def solve_b(input) do
    input
    |> parse
    |> count_required_bags("shiny gold")
    |> (&(&1 - 1)).()
  end

  def parse(lines) when is_list(lines) do
    Enum.map(lines, &parse/1)
    |> Map.new
  end

  def parse(line) when is_binary(line) do
    case Regex.run(~r/^(.+?) bags contain no other bags.$/, line, capture: :all_but_first) do
      [bag] -> {bag, %{}}
      nil -> parse_complex_line(line)
    end
  end

  def parse_complex_line(line) do
    [bag] = Regex.run(~r/^(.+?) bags contain/, line, capture: :all_but_first)
    {bag, 
     line
     |> String.replace(bag <> " bags contain ", "")
     |> String.split(",")
     |> Enum.map(fn part -> Regex.run(~r/(\d+) (.+?) bags?/, part, capture: :all_but_first) end)
     |> Enum.reduce(%{}, fn [count, bag], bags -> Map.put(bags, bag, String.to_integer(count)) end)}
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
