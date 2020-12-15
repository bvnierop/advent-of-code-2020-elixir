defmodule AdventOfCode.Day15RambunctiousRecitationTest do
  use ExUnit.Case
  doctest AdventOfCode.Day15RambunctiousRecitation
  import AdventOfCode.Day15RambunctiousRecitation

  @tests [
    {[0,3,6], 436},
    {[1,3,2], 1},
    {[2,1,3], 10},
    {[1,2,3], 27},
    {[2,3,1], 78},
    {[3,2,1], 438},
    {[3,1,2], 1836}
  ]

  test "parse" do
    assert parse(["0,3,6"]) == [0,3,6]
  end

  test "play game" do
    stream = stream([0, 3, 6])
    assert Enum.take(stream, 5) == [0, 3, 6, 0, 3]

    assert Enum.at(stream, 2019) == 436
  end

  test "play all test games" do
    Enum.each(@tests, fn {start, result} ->
      game_number = start |> stream |> Enum.at(2019)
      assert game_number == result
    end)
  end
end
