defmodule AdventOfCode.Day05BinaryBoardingTest do
  use ExUnit.Case
  doctest AdventOfCode.Day05BinaryBoarding

  import AdventOfCode.Day05BinaryBoarding

  @tests [{"FBFBBFFRLR", 44, 5, 357},
          {"BFFFBBFRRR", 70, 7, 567},
          {"FFFBBBFRRR", 14, 7, 119},
          {"BBFFBBFRLL", 102, 4, 820}]

  test "splits chunks" do
    Enum.each(@tests, fn {input, row, column, id} ->
      assert parse_seat(input) == {row, column, id}
    end)
  end
end
