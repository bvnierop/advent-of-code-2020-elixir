defmodule AdventOfCode.Day17ConwayCubes do
  use AdventOfCode

  defmodule Life do
    defmodule N do
      def n(orig, [], cur, acc) do
        coord = Enum.reverse(cur) |> List.to_tuple
        if coord != orig, do: [coord | acc], else: acc
      end

      def n(orig, [n | rest], cur, acc) do
        1..-1
        |> Enum.reduce(acc, fn dn, acc -> n(orig, rest, [n + dn | cur], acc) end)
      end

    end
    def neighbours(coord) do
      as_list = Tuple.to_list(coord)
      N.n(coord, as_list, [], [])
    end

    def step(state) do
      state
      |> activate
      |> deactivate
    end

    def activate(state) do
      # For each cell
      # Look at the neighbours
      # Count them in a map
      # For each cell that has exactly 3 living neighbours, add them.
      new_state = state
      |> Enum.reduce(%{}, fn cell, acc ->
        neighbours(cell)
        |> Enum.reduce(acc, fn neighbour, acc -> Map.put(acc, neighbour, (acc[neighbour] || 0) + 1) end)
      end)
      |> Enum.filter(fn {_cell, living_neighbours} -> living_neighbours == 3 end)
      |> Enum.map(fn {cell, _living_neighbours} -> cell end)
      |> MapSet.new

      {state, new_state}
    end

    def deactivate({state, new_state}) do
      # For each cell
      # Count neighbours that are active
      # If not 2 or 3, reject them
      state
      |> Enum.filter(fn coord ->
        case neighbours(coord) |> Enum.count(&MapSet.member?(state, &1)) do
          2 -> true
          3 -> true
          _ -> false
        end
      end)
      |> MapSet.new
      |> MapSet.union(new_state)
    end

    def to_string(state) do
      {{_, _, minz}, {_, _, maxz}} = Enum.min_max_by(state, fn {_x, _y, z} -> z end)
      slices = for z <- minz..maxz, do: slice_to_string(state, z)
      Enum.join(slices, "\n\n")
    end

    def slice_to_string(state, z) do
      {{_, miny, _}, {_, maxy, _}} = Enum.min_max_by(state, fn {_x, y, _z} -> y end)
      lines = for y <- miny..maxy, do: line_to_string(state, y, z)
      Enum.join(["z=#{z}" | lines], "\n")
    end

    def line_to_string(state, y, z) do
      {{minx, _, _}, {maxx, _, _}} = Enum.min_max_by(state, fn {x, _y, _z} -> x end)
      for x <- minx..maxx, into: "", do: (if MapSet.member?(state, {x, y, z}), do: "#", else: ".")
    end

    def stream(state) do
      Stream.iterate(state, &step/1)
    end
  end

  def solve_a(input) do
    input
    |> parse
    |> Life.stream
    |> Enum.at(6)
    |> MapSet.size
  end

  def solve_b(input) do
    input
    |> parse
    |> add_dimension
    |> Life.stream
    |> Enum.at(6)
    |> MapSet.size
  end

  def add_dimension(state) do
    state
    |> Enum.map(fn {x, y, z} -> {x, y, z, 0} end)
    |> MapSet.new
  end

  def parse(input) do
    input
    |> Enum.with_index
    |> Enum.reduce(MapSet.new, fn {line, y}, acc ->
      line
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(acc, fn
        {"#", x}, acc -> MapSet.put(acc, {x, y, 0})
        _, acc -> acc
      end)
    end)
  end
end
