defmodule AdventOfCode.Day20JurassicJigsawTest do
  use ExUnit.Case
  doctest AdventOfCode.Day20JurassicJigsaw
  import AdventOfCode.Day20JurassicJigsaw

  alias AdventOfCode.Day20JurassicJigsaw.Parser, as: Parser

  test "solve", do: solve_a([])

  @test_tile """
  Tile 3:
  .#.#
  ....
  ..##
  #...
  """ |> String.trim |> String.split("\n")

  @test_tiles """
  Tile 3:
  .#.#
  ....
  ..##
  #...

  Tile 4:
  .#.#
  ....
  ..##
  #...
  """ |> String.trim |> String.split("\n")

  test "parse tile" do
    assert Parser.parse_tile(@test_tile) == %{:id => 3,
                                              :raw => [".#.#",
                                                       "....",
                                                       "..##",
                                                       "#..."],
                                              :edges => [".#.#", "#.#.", "#...", "...#"]}
  end

  test "parse tiles" do
    assert Parser.parse(@test_tiles) |> Enum.map(&(&1.id)) == [3, 4]
  end
end
