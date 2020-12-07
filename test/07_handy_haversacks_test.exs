defmodule AdventOfCode.Day07HandyHaversacksTest do
  use ExUnit.Case
  doctest AdventOfCode.Day05BinaryBoarding
  doctest AdventOfCode.Day07HandyHaversacks

  import AdventOfCode.Day07HandyHaversacks

  @lines [
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    # "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    # "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    # "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    # "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    # "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags."
  ]

  @all_lines [
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags."
  ]

  @graph %{"shiny gold" => %{"bright white" => 1, "muted yellow" => 2},
           "faded blue" => %{"muted yellow" => 9},
           "muted yellow" => %{"light red" => 2},
           "bright white" => %{"light red" => 1}}

  test "parses input" do
    assert parse(@lines) == @graph
  end

  test "finds out which bags can (indirectly) contain a another bag" do
    assert find_bags_containing(@graph, "shiny gold") == MapSet.new(["bright white", "muted yellow", "light red"])
  end

  test "invert graph" do
    assert invert(@graph) == %{"light red" => %{"bright white" => 1, "muted yellow" => 2},
                               "bright white" => %{"shiny gold" => 1},
                               "muted yellow" => %{"shiny gold" => 2, "faded blue" => 9}}
  end

  test "count bags" do
    assert count_required_bags(invert(parse(@all_lines)), "shiny gold") == 33
  end
end
