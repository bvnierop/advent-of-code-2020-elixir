defmodule AdventOfCode.Day19MonsterMessagesTest do
  use ExUnit.Case
  doctest AdventOfCode.Day19MonsterMessages
  import AdventOfCode.Day19MonsterMessages

  alias AdventOfCode.Day19MonsterMessages.RuleEngine, as: RuleEngine

  test "parse rules" do
    rules = """
    0: 1 2
    1: "a"
    2: 1 3 | 3 1
    3: "b"
    """ |> String.trim |> String.split("\n")

    assert RuleEngine.parse(rules) == %{
      0 => [[1, 2]],
      1 => "a",
      2 => [[1, 3], [3, 1]],
      3 => "b",
    }
  end

  test "execute rules" do
    # Let's make some notes first.
    # A rule is executed on some state / input
    # If a rule contains several subrules, input and subrule are incremented together
    # Which means that every rule execution must also return its new state

    # The simplest rule to test would be 0: "a", with inputs of "", "a", "b" and "aa"
    # From there, we can delve into combinations, and from there into options
    rulebook = %{0 => "a"}

    assert RuleEngine.match?(rulebook, "") == false
    assert RuleEngine.match?(rulebook, "a") == true
    assert RuleEngine.match?(rulebook, "b") == false
    assert RuleEngine.match?(rulebook, "ab") == false

    # So the next one is a redirect
    redirect_book = %{0 => [[1]], 1 => "a"}

    # This one matches "a".
    assert RuleEngine.match?(redirect_book, "a") == true
    assert RuleEngine.match?(redirect_book, "aa") == false

    # Now that we can redirect, let's concatenate
    combined_book = %{0 => [[1, 1]], 1 => "a"}
    assert RuleEngine.match?(combined_book, "a") == false
    assert RuleEngine.match?(combined_book, "aa") == true
    assert RuleEngine.match?(combined_book, "aaa") == false

    # Finally, implement alternatives
    # This book matches "ab", or "b"
    alternative_book = %{0 => [[1, 2], [2]], 1 => "a", 2 => "b"}
    assert RuleEngine.match?(alternative_book, "a") == false
    assert RuleEngine.match?(alternative_book, "b") == true
    assert RuleEngine.match?(alternative_book, "ab") == true
    assert RuleEngine.match?(alternative_book, "ba") == false
    assert RuleEngine.match?(alternative_book, "aa") == false
    assert RuleEngine.match?(alternative_book, "bb") == false

    # And there's a really tricky case that I don't think exists in this problem...
    # We can solve this by ordering by length.
    tricky_book = %{0 => [[1], [1, 1]], 1 => "a"} # matches both "a" and "aa"
    assert RuleEngine.match?(tricky_book, "a") == true
    assert RuleEngine.match?(tricky_book, "aa") == true
    assert RuleEngine.match?(tricky_book, "aaa") == false

    trickier_book = %{0 => [[1, 2]],
                      1 => [[10, 11], [10]],
                      2 => [[11, 10, 10]],
                      10 => "a", 11 => "b"}
    assert RuleEngine.match?(trickier_book, "abaa") == true
  end

  @test_input """
  0: 4 1 5
  1: 2 3 | 3 2
  2: 4 4 | 5 5
  3: 4 5 | 5 4
  4: "a"
  5: "b"

  ababbb
  bababa
  abbbab
  aaabbb
  aaaabbb
  """ |> String.trim |> String.split("\n")

  test "parse input" do
    assert parse(@test_input) == {
      %{0 => [[4, 1, 5]],
        1 => [[2, 3], [3, 2]],
        2 => [[4, 4], [5, 5]],
        3 => [[4, 5], [5, 4]],
        4 => "a",
        5 => "b"},
      ["ababbb",
       "bababa",
       "abbbab",
       "aaabbb",
       "aaaabbb"]}
  end

  test "solve a" do
    assert solve_a(@test_input) == 2
  end

  test "recursive rules" do
    rules = """
    0: 2
    1: "a"
    2: 1 2 | 1
    """ |> String.trim |> String.split("\n")
    recursive_book = RuleEngine.parse(rules)

    assert RuleEngine.match?(recursive_book, "a") == true
    assert RuleEngine.match?(recursive_book, "aa") == true
    assert RuleEngine.match?(recursive_book, "aaa") == true
    assert RuleEngine.match?(recursive_book, "aaaa") == true
  end

  test "solve it, specific first, then hardcoded" do
    book = %{0 => [[1, 2]],
                      1 => [[10, 11], [10]],
                      2 => [[11, 10, 10]],
                      10 => "a", 11 => "b"}
    input = "abaa"

    assert RuleEngine.reduce(0, book, MapSet.new([""]), "abaa") == MapSet.new(["abaa"])
    assert RuleEngine.find(book, input) == true
  end
end
