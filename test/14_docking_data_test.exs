defmodule AdventOfCode.Day14DockingDataTest do
  use ExUnit.Case
  doctest AdventOfCode.Day14DockingData
  import AdventOfCode.Day14DockingData

  alias AdventOfCode.Day14DockingData.Parser, as: Parser
  alias AdventOfCode.Day14DockingData.Computer, as: Computer

  @test_input """
  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  """ |> String.trim |> String.split("\n")

  test "solve", do: solve_a([])

  test "parse" do
    assert Parser.parse(@test_input) == [
      {:mask, 0b111111111111111111111111111111111101, 0b000000000000000000000000000001000000},
      {:mem, 8, 11},
      {:mem, 7, 101},
      {:mem, 8, 0},
    ]
  end

  test "apply mask" do
    mask = {0b111111111111111111111111111111111101, 0b000000000000000000000000000001000000}
    assert Computer.apply_mask(11, mask) == 73
  end

  test "run the program" do
    instructions = Parser.parse(@test_input)
    assert Computer.reduce(instructions) == %{7 => 101, 8 => 64}
  end
end
