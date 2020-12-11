defmodule AdventOfCode.Day11SeatingSystem do
  use AdventOfCode

  defmodule Layout do
    def parse(input) do
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {row, y}, layout ->
        Enum.reduce(row, layout, fn {seat, x}, layout ->
          Map.put(layout, {x, y}, seat)
        end)
      end)
    end

    def neighbours(layout, x, y) do
      for xx <- (x-1)..(x+1),
        yy <- (y-1)..(y+1),
        x != xx || y != yy,
        do: layout[{xx, yy}]
    end

    @directions [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
    def find_neighbours(layout, x, y, allowed \\ [".", "L", "#"]) do
      @directions
      |> Enum.map(fn {dx, dy} ->
        find_neighbour(layout, x + dx, y + dy, {dx, dy}, allowed)
      end)
      |> Enum.reject(&(&1 == nil))
    end

    def find_neighbour(layout, x, y, {offset_x, offset_y}, allowed) do
      seat = layout[{x, y}]
      cond do
        seat in allowed -> {x, y}
        seat == nil -> nil
        :else -> find_neighbour(layout, x + offset_x, y + offset_y, {offset_x, offset_y}, allowed)
      end
    end

    def build_neighbour_cache(layout, neighbours) do
      Enum.map(layout, fn {{x, y}, _} -> {{x, y}, Layout.find_neighbours(layout, x, y, neighbours)} end)
      |> Map.new
    end
  end

  defmodule Simulation do
    def stream(layout, occupied_threshold, neighbours \\ ["L", "#", "."]) do
      cache = Layout.build_neighbour_cache(layout,neighbours)
      Stream.iterate(layout, &step(&1, occupied_threshold, cache))
    end

    def step(layout, occupied_threshold, neighbours) do
      {max_x, max_y} = Map.keys(layout) |> Enum.max

      for x <- 0..max_x,
        y <- 0..max_y,
        into: %{} do
          seat = layout[{x, y}]
          if seat in ["L", "#"] do
            occupied_neighbours = neighbours[{x, y}]
            |> Enum.count(fn pos -> layout[pos] == "#" end)
            case {seat, occupied_neighbours} do
              {"L", 0} -> {{x, y}, "#"}
              {"#", n} when n >= occupied_threshold -> {{x, y}, "L"}
              {_, _} -> {{x, y}, seat}
            end
          else
            {{x, y}, seat}
          end
      end
    end
  end

  def solve_a(input) do
    layout = Layout.parse(input)
    stream = Simulation.stream(layout, 4)

    Enum.reduce_while(stream, %{}, fn
      state, prev when state == prev -> {:halt, state}
      state, _prev -> {:cont, state}
    end)
    |> Enum.count(fn {_key, seat} -> seat == "#" end)
  end

  def solve_b(input) do
    layout = Layout.parse(input)
    stream = Simulation.stream(layout, 5, ["L", "#"])

      Enum.reduce_while(stream, %{}, fn
        state, prev when state == prev -> {:halt, state}
      state, _prev -> {:cont, state}
    end)
    |> Enum.count(fn {_key, seat} -> seat == "#" end)
  end
end
