defmodule AdventOfCode.Day16TicketTranslation do
  use AdventOfCode

  defmodule Parser do
    def parse(input) do
      {lines, fields} = parse_fields(input, %{})
      {lines, ticket} = parse_your_ticket(lines)
      {_, tickets} = parse_tickets(lines)
      %{
        :fields => fields,
        :ticket => ticket,
        :nearby => tickets
      }
    end

    def parse_fields([line | lines], acc) do
      case Regex.run(~r/(.+): (\d+)-(\d+) or (\d+)-(\d+)/, line, capture: :all_but_first) do
        [field, lo1, hi1, lo2, hi2] ->
          parse_fields(lines, Map.put(acc, field, [(String.to_integer(lo1))..(String.to_integer(hi1)),
                                                  (String.to_integer(lo2))..(String.to_integer(hi2))]))
        _ -> {lines, acc}
      end
    end

    def parse_your_ticket(["your ticket:" | [ticket | ["" | lines]]]), do: {lines, parse_ticket(ticket)}

    def parse_tickets(["nearby tickets:" | tickets]) do
      {[], Enum.map(tickets, &parse_ticket/1)}
    end

    def parse_ticket(line) do
      line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    end
  end

  def solve_a(input) do
    data = Parser.parse(input)
    Enum.flat_map(data.nearby, &(invalid_values(&1, data.fields)))
    |> Enum.sum
  end

  def solve_b(input) do
    data = Parser.parse(input)

    _field_indices = id_fields([data.ticket | valid_tickets(data)], data.fields)
    |> Enum.filter(fn
      {"departure " <> _, _} -> true
      {_, _} -> false
    end)
    |> Enum.map(fn {_key, index} -> elem(data.ticket, index) end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def potential_fields(idx, tickets, fields, used) do
    values_at_idx = Enum.map(tickets, &(elem(&1, idx)))

    _potential_fields = Map.keys(fields)
    |> Enum.reject(&Map.has_key?(used, &1))
    |> Enum.filter(fn field_name ->
      ranges = fields[field_name]
      Enum.all?(values_at_idx, fn value ->
        Enum.any?(ranges, fn range ->
          value in range
        end)
      end)
    end)
  end

  def id_fields(tickets, fields) do
    {first_field, first_idx} = first = next_pick(tickets, fields, %{})
    Stream.unfold({first, Map.put(%{}, first_field, first_idx)}, fn
      nil ->
        nil
      {pick, used} ->
        case next_pick(tickets, fields, used) do
          {field, idx} -> {pick, {{field, idx}, Map.put(used, field, idx)}}
          nil -> {pick, nil}
        end
    end)
    |> Map.new
  end

  def next_pick(tickets, fields, used) do
    0..(tuple_size(Enum.at(tickets, 0)) - 1)
    |> Enum.map(fn idx -> potential_fields(idx, tickets, fields, used) end)
    |> Enum.with_index
    |> Enum.find_value(fn
      {[field], index} -> {field, index}
      {_, _index} -> nil
    end)
  end

  def invalid_values(ticket, fields) do
    ranges = Map.values(fields) |> Enum.flat_map(fn x -> x end)
    Tuple.to_list(ticket)
    |> Enum.reject(fn val -> Enum.find(ranges, fn range -> val in range end) end)
  end

  def valid?(ticket, fields) do
    invalid_values(ticket, fields) == []
  end

  def valid_tickets(data) do
    Enum.filter(data.nearby, &(valid?(&1, data.fields)))
  end
end
