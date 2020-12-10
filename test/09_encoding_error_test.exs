defmodule AdventOfCode.Day09EncodingErrorTest do
  use ExUnit.Case
  doctest AdventOfCode.Day09EncodingError
  import AdventOfCode.Day09EncodingError
  @test_input """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """ |> String.trim |> String.split("\n")

  test "parse input" do
    assert parse(@test_input) |> Enum.take(5) == [35, 20, 15, 25, 47]
  end

  test "valid" do
    assert valid?([1, 2, 3, 4, 5, 1]) == false
    assert valid?([1, 2, 3, 4, 5, 2]) == false
    assert valid?([1, 2, 3, 4, 5, 3]) == true
  end

  test "first invalid" do
    assert first_invalid(parse(@test_input), 5) == 127
  end

  test "find sum" do
    assert find_sequence(parse(@test_input), 127) == [15, 25, 47, 40]
  end
end
