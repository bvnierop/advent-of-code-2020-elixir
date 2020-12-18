defmodule AdventOfCode.Day18OperationOrder do
  use AdventOfCode

  defmodule Parser do
    def tokenize(str) do
      str
      |> String.replace("(", " ( ")
      |> String.replace(")", " ) ")
      |> String.split([" "], trim: true)
    end

    def make_groups(tokens) do
      as_group = ["("] ++ tokens ++ [")"]
      {group, remaining_tokens} = parse_group(as_group)
      if remaining_tokens != [], do: raise "NO FULL GROUP WAS PARSED"
      group
    end

    defp parse_group(["(" | remaining]), do: parse_group(remaining, [])

    defp parse_group([token | remaining] = tokens, group) do
      case parse_token(token) do
        {:begin_group, _} ->
          {nested, remaining} = parse_group(tokens)
          parse_group(remaining, [nested | group])
        {:end_group, _} -> {{:group, Enum.reverse(group)}, remaining}
        tok -> parse_group(remaining, [tok | group])
      end
    end

    defp parse_token("("), do: {:begin_group, []}
    defp parse_token(")"), do: {:end_group, []}
    defp parse_token("+"), do: {:operator, :add}
    defp parse_token("*"), do: {:operator, :mul}
    defp parse_token(other), do: {:number, String.to_integer(other)}

    def make_expression({:group, group}, precedence \\ %{:group => 99, :add => 1, :mul => 1}) do
      _expr = make_expression(group, nil, precedence)
    end

    # End on an empty list
    def make_expression([], expr, _precedence), do: expr
    def make_expression([cur | remaining], expr, precedence) do
      case {cur, expr} do
        {{:group, _} = nested, nil} -> make_expression(remaining, {:group, make_expression(nested, precedence)}, precedence)
        {{:group, _} = nested, {op, lhs}} ->
          make_expression(remaining, {op, lhs, {:group, make_expression(nested, precedence)}}, precedence)
        {{:number, num}, nil} -> make_expression(remaining, {:value, num}, precedence)
        {{:number, num}, {op, lhs}} -> make_expression(remaining, {op, lhs, {:value, num}}, precedence)
        {{:operator, op}, {:value, _} = expr} -> make_expression(remaining, {op, expr}, precedence)
        {{:operator, op}, {:group, _} = expr} -> make_expression(remaining, {op, expr}, precedence)
        {{:operator, op}, {e_op, e_lhs, e_rhs} = expr} ->
          if precedence[e_op] < precedence[op] do
            {e_op, e_lhs, make_expression(remaining, {op, e_rhs}, precedence)}
          else
            make_expression(remaining, {op, expr}, precedence)
          end
      end
    end

    # How do we add precedence to this?
    # 1 * 2 + 3 * 4
    # (1 * 2) + (3 * 4) (let's not confuse ourselves with _weird_ precedence yet)
    # 1 -> expr: {:value, 1}
    # * -> expr: {:mul, {:value, 1}}
    # 2 -> expr: {:mul, {:value, 1}, {:value, 2}}
    # + -> expr: {:add, {:mul, {:value, 1}, {:value, 2}}}
    # 3 -> expr: {:add, {:mul, {:value, 1}, {:value, 2}}, {:value, 3}}
    # * -> expr: {:add, {:mul, {:value, 1}, {:value, 2}}, {:mul, {:value, 3}}} !!!
    #    _WHY_, formally, do we start building the RHS instead of a new op?
    #    The answer: We start building the RHS if, and only if, the precence of the operator is strictly _higher_ than the one we're building

    def parse(str, precedence \\ %{:add => 1, :mul => 1}) do
      str
      |> tokenize
      |> make_groups
      |> make_expression(precedence)
    end
  end

  def eval({:value, val}), do: val
  def eval({:group, expr}), do: eval(expr)
  def eval({:add, lhs, rhs}), do: eval(rhs) + eval(lhs)
  def eval({:mul, lhs, rhs}), do: eval(rhs) * eval(lhs)

  def solve_a(input) do
    input
    |> Enum.map(&Parser.parse/1)
    |> Enum.map(&eval/1)
    |> Enum.sum
  end

  def solve_b(input) do
    p = %{:group => 99, :mul => 1, :add => 2}
    input
    |> Enum.map(&Parser.parse(&1, p))
    |> Enum.map(&eval/1)
    |> Enum.sum
  end
end
