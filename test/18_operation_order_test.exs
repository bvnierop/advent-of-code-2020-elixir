defmodule AdventOfCode.Day18OperationOrderTest do
  use ExUnit.Case
  doctest AdventOfCode.Day18OperationOrder
  import AdventOfCode.Day18OperationOrder

  alias AdventOfCode.Day18OperationOrder.Parser, as: Parser

  test "solve", do: solve_a([])

  test "tokenize" do
    assert Parser.tokenize("7 * (14 + 2)") == ["7", "*", "(", "14", "+", "2", ")"]
  end

  test "make groups of tokens" do
    assert Parser.make_groups(Parser.tokenize("7 * 2 + 4 * (5 + 6)")) == {:group, [
                                                                            {:number, 7},
                                                                            {:operator, :mul},
                                                                            {:number, 2},
                                                                            {:operator, :add},
                                                                            {:number, 4},
                                                                            {:operator, :mul},
                                                                            {:group, [
                                                                                {:number, 5},
                                                                                {:operator, :add},
                                                                                {:number, 6}
                                                                              ]}
                                                                          ]}
  end

  test "build expressions" do
    number = Parser.make_groups(Parser.tokenize("5"))
    assert Parser.make_expression(number) == {:value, 5}

    expr = Parser.make_groups(Parser.tokenize("5 + 3"))
    assert Parser.make_expression(expr) == {:add, {:value, 5}, {:value, 3}}

    with_groups = Parser.make_groups(Parser.tokenize("5 + (2 * 3)"))
    assert Parser.make_expression(with_groups) == {:add,
                                                   {:value, 5},
                                                   {:group, {:mul, {:value, 2}, {:value, 3}}}}

    chained = Parser.make_groups(Parser.tokenize("5 + 2 * 3"))
    assert Parser.make_expression(chained) == {:mul,
                                               {:add, {:value, 5}, {:value, 2}},
                                               {:value, 3}}

    complex = Parser.make_groups(Parser.tokenize("7 * 2 + 4 * (5 + 6)"))
    assert Parser.make_expression(complex) == {:mul,
                                               {:add,
                                                {:mul, {:value, 7}, {:value, 2}},
                                                {:value, 4}},
                                               {:group, {:add, {:value, 5}, {:value, 6}}}}
  end

  test "build expression with precedence" do
    # 1 * 2 + 3 * 4
    # + -> expr: {:add, {:mul, {:value, 1}, {:value, 2}}, {:mul, {:value, 3}, {:value, 4}}}

    #    The answer: We start building the RHS if, and only if, the precence of the operator is strictly _higher_ than the one we're building
    simple = Parser.make_groups(Parser.tokenize("1 * 2 + 3 * 4"))
    precedence = %{:add => 1, :mul => 2}

    assert Parser.make_expression(simple, precedence) == {:add,
                                                          {:mul,
                                                           {:value, 1},
                                                           {:value, 2}},
                                                          {:mul,
                                                           {:value, 3},
                                                           {:value, 4}}}

    with_groups = Parser.make_groups(Parser.tokenize("(2 * 3) + (4 * 5)"))
    assert Parser.make_expression(with_groups, precedence) == {:add,
                                                               {:group, {:mul, {:value, 2}, {:value, 3}}},
                                                               {:group, {:mul, {:value, 4}, {:value, 5}}}}
  end

  test "evaluate expression" do
    assert eval({:value, 5}) == 5
    assert eval({:add, {:value, 5}, {:value, 3}}) == 8
    assert eval({:mul, {:value, 5}, {:value, 3}}) == 15

    assert eval(Parser.parse("5 + 2")) == 7
    assert eval(Parser.parse("((5 + 2))")) == 7
    assert eval(Parser.parse("1 + 2 * 3 + 4 * 5 + 6")) == 71
    assert eval(Parser.parse("2 * 3 + (4 * 5)")) ==  26
    assert eval(Parser.parse("5 + (8 * 3 + 9 + 3 * 4 * 3)")) ==  437
    assert eval(Parser.parse("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))")) ==  12240
    assert eval(Parser.parse("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2")) == 13632
  end

  test "evaluate expressions with precedence" do
    p = %{:group => 99, :mul => 1, :add => 2}

    assert eval(Parser.parse("1 + 2 * 3 + 4 * 5 + 6", p)) == 231
    assert eval(Parser.parse("1 + (2 * 3) + (4 * (5 + 6))", p)) ==  51
    assert eval(Parser.parse("2 * 3 + (4 * 5)", p)) ==  46
    assert eval(Parser.parse("5 + (8 * 3 + 9 + 3 * 4 * 3)", p)) ==  1445
    assert eval(Parser.parse("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", p)) ==  669060
    assert eval(Parser.parse("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", p)) ==  23340

    assert eval(Parser.parse("(2 * 3) + (4 * 5)", p)) == (2 * 3) + (4 * 5)

    assert eval(Parser.parse("(4 * 5 * (2 + 7 + 5)) * 7 + (6 + 5 + (7 * 6 * 8) * 4 + 5 * (2 * 9 + 6 * 4 * 4 * 2)) + ((5 + 3 + 7 * 2 * 7 * 8) + 7 * 3 + 5 + (5 * 2)) * 3 + 7", p)) == 8479668400
  end

  test "solve a" do
    expressions = ["5 + 2", "1 + 2 * 3 + 4 * 5 + 6"]
    assert solve_a(expressions) == 78
  end

  test "solve b" do
    expressions = ["1 + (2 * 3) + (4 * (5 + 6))",
                   "2 * 3 + (4 * 5)",
                   "5 + (8 * 3 + 9 + 3 * 4 * 3)",
                   "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))",
                   "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"]
    expected_result = 51 + 46 + 1445 + 669060 + 23340
    assert solve_b(expressions) == expected_result
  end
end
