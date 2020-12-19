defmodule AdventOfCode.Day17ConwayCubesTest do
  use ExUnit.Case
  doctest AdventOfCode.Day17ConwayCubes
  import AdventOfCode.Day17ConwayCubes

  alias AdventOfCode.Day17ConwayCubes.Life, as: Life

  @test_input """
  .#.
  ..#
  ###
  """ |> String.trim |> String.split("\n")

  test "parse" do
    assert parse(@test_input) == MapSet.new([{1, 0, 0}, {2, 1, 0}, {0, 2, 0}, {1, 2, 0}, {2, 2, 0}])
  end

  test "neighbours" do
    assert Life.neighbours({0, 0, 0}) |> Enum.count == 26
  end

  test "print" do
    assert Life.to_string(parse(@test_input)) ==
      """
      z=0
      .#.
      ..#
      ###
      """ |> String.trim
  end

  test "step" do
    assert Life.to_string(Life.step(parse(@test_input))) ==
      """
      z=-1
      #..
      ..#
      .#.

      z=0
      #.#
      .##
      .#.

      z=1
      #..
      ..#
      .#.
      """ |> String.trim
  end

  test "stream" do
    inp = parse(@test_input)
    stream = Life.stream(inp)
    state = Enum.at(stream, 6)
    assert MapSet.size(state) == 112
  end

  test "part 1" do
    assert solve_a(@test_input) == 112
  end

  test "neighbours with variable dimensions" do
    assert Life.neighbours({0, 0}) |> Enum.count == 8
    assert Life.neighbours({0, 0, 0}) |> Enum.count == 26
    assert Life.neighbours({0, 0, 0, 0}) |> Enum.count == 80

    assert Life.neighbours({5, 10}) |> Enum.find(fn coord -> coord == {4, 11} end)
    assert Life.neighbours({5, 10}) |> Enum.find(fn coord -> coord == {5, 10} end) == nil
  end

  test "part 2" do
    assert solve_b(@test_input) == 848
  end
end
