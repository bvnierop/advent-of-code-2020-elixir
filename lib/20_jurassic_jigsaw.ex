defmodule AdventOfCode.Day20JurassicJigsaw do
  use AdventOfCode

  defmodule Parser do
    def parse(input) do
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(&parse_tile/1)
    end

    def parse_tile(["Tile " <> id_plus_colon | raw] = _tile) do
      {id, _ } = Integer.parse(id_plus_colon)
      %{:id => id,
        :raw => raw,
        :edges => parse_edges(raw)}
    end

    defp parse_edges(raw) do
      [Enum.at(raw, 0), # top
       Enum.map(raw, &String.at(&1, -1)) |> Enum.join(""), #right
       Enum.at(raw, -1), # bottom
       Enum.map(raw, &String.at(&1, 0)) |> Enum.join("")] #left
    end
  end

  defmodule Verifier do
    def verify(input) do
      # a) read all tiles
      tiles = Parser.parse(input)

      # b) count all edges
      edge_counts = count_edges(tiles)

      # c) group them by how often they occur
      # d) verify the puzzle input by above rules
      # - Some edges should occur exactly once
      #   > The outsides: ~4 * sqrt(N)~
      # - All other should occur exactly twice
      #   > The insides: ~(4 * N) - outsides~
      singles = Enum.count(edge_counts, fn {_edge, count} -> count == 1 end)
      doubles = Enum.count(edge_counts, fn {_edge, count} -> count == 2 end) * 2

      n = Enum.count(tiles)
      sides = round(:math.sqrt(n))

      %{
        :n => n,
        :sides => sides,
        :singles => singles,
        :doubles => doubles,
        :singles_req => 4 * sides,
        :doubles_req => 4 * n - 4 * sides
      }
    end

    def count_edges(tiles) do
      edges = Enum.flat_map(tiles, &(&1.edges))
      edges = Enum.map(edges, fn edge -> [edge, String.reverse(edge)] |> Enum.sort end)
      Enum.reduce(edges, %{}, fn edge, counts ->
        Map.put(counts, edge, (counts[edge] || 0) + 1)
      end)
    end
  end

  defmodule A do
    def solve(tiles) do
      Enum.map(tiles, fn tile ->
        {tile.id, Enum.count(tiles, fn other ->
          matching_edge?(tile, other)
        end) - 1} # because it always matches itself
      end)
      |> Enum.filter(fn {_id, count} -> count == 2 end)
      |> Enum.map(&(elem(&1, 0)))
      |> Enum.reduce(1, &(&1 * &2))
    end

    def matching_edge?(a, b) do
      ae = Enum.map(a.edges, fn edge -> [edge, String.reverse(edge)] |> Enum.sort end) |> MapSet.new
      be = Enum.map(b.edges, fn edge -> [edge, String.reverse(edge)] |> Enum.sort end) |> MapSet.new

      MapSet.intersection(ae, be) != MapSet.new
    end
  end


  def solve_a(input) do
    # input |> Verifier.verify
    # Enum.at(input, 0)
    input
    |> Parser.parse
    |> A.solve
  end

  def solve_b(input) do
    Enum.at(input, 0)
  end
end
