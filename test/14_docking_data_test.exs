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

  test "build stream" do
    assert Computer.next("XXX") == 0
    assert Computer.next("XXX", 0) == 1
    assert Computer.next("XXX", 1) == 2
    assert Computer.next("XXX", 7) == nil

    assert Computer.next("XX1") == 1

    assert Computer.next("X0X", 1) == 0b100

    # "X1X"
    # 010
    # 011
    # 110
    # 111
    assert Computer.next("X1X", 0b11) == 0b110

    assert Enum.to_list(Computer.stream("X1X")) == [0b010, 0b011, 0b110, 0b111]
    assert Enum.to_list(Computer.stream("X0X")) == [0b000, 0b001, 0b100, 0b101]
    assert Enum.to_list(Computer.stream("0X0X")) == [0b000, 0b001, 0b100, 0b101]
  end

  test "apply mask part 2" do
    assert Computer.apply_mask2(0b101010, "00XX1100") == "00XX1110"
  end
end
