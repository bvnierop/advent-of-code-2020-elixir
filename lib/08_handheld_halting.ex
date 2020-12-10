defmodule AdventOfCode.Day08HandheldHalting do
  use AdventOfCode

  defmodule Instruction do
    def parse(line) do
      [op, offset] = String.split(line, " ")
      {String.to_atom(op), String.to_integer(offset)}
    end
  end

  defmodule Program do
    def parse(lines) do
      Enum.map(lines, &Instruction.parse/1)
      |> Enum.concat([{:fin, 0}])
      |> List.to_tuple
    end

    def get(program, line) do
      elem(program, line)
    end
  end

  defmodule Handheld do
    def stream(program) do
      Stream.iterate({0, 0}, &step(program, &1))
    end

    def step(program, {ip, acc}) do
      case Program.get(program, ip) do
        {:nop, _} -> {ip + 1, acc}
        {:jmp, offset} -> {ip + offset, acc}
        {:acc, value} -> {ip + 1, acc + value}
      end
    end

    def with_history(stream) do
      Stream.transform(stream, MapSet.new, fn {ip, _} = step, history ->
        {[{step, history}], MapSet.put(history, ip)}
      end)
    end

    def run_and_patch(program, {ip, acc, history}, patched) do
      unless MapSet.member?(history, ip) do
        history = MapSet.put(history, ip)
        case Program.get(program, ip) do
          {:nop, offset} -> run_and_patch(program, {ip + 1, acc, history}, patched) ||
            (unless patched, do: run_and_patch(program, {ip + offset, acc, history}, true))
          {:jmp, offset} -> run_and_patch(program, {ip + offset, acc, history}, patched) ||
            (unless patched, do: run_and_patch(program, {ip + 1, acc, history}, true))
          {:acc, value} -> run_and_patch(program, {ip + 1, acc + value, history}, patched)
          {:fin, _} -> {ip, acc}
        end
      end
    end
  end

  def solve_a(input) do
    input
    |> Program.parse
    |> Handheld.stream
    |> Handheld.with_history
    |> Enum.find(fn {{ip, _acc}, history} -> MapSet.member?(history, ip) end)
  end

  def solve_b(input) do
    input
    |> Program.parse
    |> Handheld.run_and_patch({0, 0, MapSet.new}, false)
  end
end
