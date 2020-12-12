defmodule AdventOfCode.Day12RainRisk do
  use AdventOfCode

  def solve_a(input) do
    {x, y, _direction} = result = input
    |> Enum.map(&parse/1)
    |> Enum.reduce({0, 0, 90}, fn {instruction, value}, {x, y, direction} ->
      case instruction do
        :R -> {x, y, Integer.mod(direction + value, 360)}
        :L -> {x, y, Integer.mod(direction - value, 360)}
        :N -> {x, y - value, direction}
        :E -> {x + value, y, direction}
        :S -> {x, y + value, direction}
        :W -> {x - value, y, direction}
        :F ->
          {dx, dy} = offset_of(direction)
          {x + dx * value, y + dy * value, direction}
      end
    end)

    {result, abs(x) + abs(y)}
  end

  def offset_of(degrees) do
    case degrees do
      0 ->   {0, -1}
      90 ->  {1, 0}
      180 -> {0, 1}
      270 -> {-1, 0}
    end
  end

  def parse(line) do
    [instruction, value] = Regex.run(~r/(\w)(\d+)/, line, capture: :all_but_first)
    { String.to_atom(instruction), String.to_integer(value)}
  end

  def solve_b(input) do
    {{sx, sy}, _} = result = input
    |> Enum.map(&parse/1)
    |> Enum.reduce({{0, 0}, {10, -1}}, fn {instruction, value}, {{sx, sy}, {wx, wy} = waypoint} ->
      case instruction do
        :F -> {{sx + wx * value, sy + wy * value}, {wx, wy}}
        :N -> {{sx, sy}, {wx, wy - value}}
        :E -> {{sx, sy}, {wx + value, wy}}
        :S -> {{sx, sy}, {wx, wy + value}}
        :W -> {{sx, sy}, {wx - value, wy}}
        :R -> {{sx, sy}, rotate(waypoint, value)}
        :L -> {{sx, sy}, rotate(waypoint, -value)}
      end
    end)

    {result, abs(sx) + abs(sy)}
  end

  def rotate(waypoint, 0), do: waypoint
  def rotate(waypoint, value) when value < 0, do: rotate(waypoint, 360 + value)
  def rotate({wx, wy}, value) do
    rotate({wy * -1, wx}, value - 90)
  end
end
