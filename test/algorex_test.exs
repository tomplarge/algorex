defmodule AlgorexTest do
  use ExUnit.Case
  alias Numerix.LinearAlgebra

  setup do
    Algorex.seed()

    :ok
  end

  defp set_balance_data(n_features, n_subjects) do
    features =
      Enum.map(1..n_features, fn _ ->
        Algorex.bernoulli(n_subjects)
      end)

    subjects =
      Enum.map(0..(n_subjects - 1), fn i ->
        Enum.map(features, &Enum.at(&1, i))
      end)

    {features, subjects}
  end

  test "bernoulli outputs 1 or 0" do
    for _ <- 1..100, do: assert(Algorex.bernoulli() in [0, 1])
  end

  test "bernoulli(n) outputs n trials of 0 or 1" do
    n = 100

    for _ <- 1..n do
      trials = Algorex.bernoulli(n)

      Enum.each(trials, &assert(&1 in [0, 1]))
      assert Kernel.length(trials) == n
    end
  end

  test "bernoulli(n, {-1,1}) outputs n trials of -1 or 1" do
    n = 100
    b = {-1, 1}

    for _ <- 1..n do
      trials = Algorex.bernoulli(n, b)

      Enum.each(trials, &assert(&1 in [-1, 1]))
      assert Kernel.length(trials) == n
    end
  end

  test "that bernoulli doesn't output same result twice in a row (probably)" do
    b1 = Algorex.bernoulli(100)
    b2 = Algorex.bernoulli(100)

    {b1, b2} =
      if b1 == b2 do
        {Algorex.bernoulli(100), Algorex.bernoulli(100)}
      else
        {b1, b2}
      end

    assert b1 != b2
  end

  test "set_balance_r doesn't duplicate subjects" do
    subjects = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    {g1, g2} = Algorex.set_balance_r(subjects)

    Enum.each(g1, fn x1 ->
      assert Enum.find_value(g2, &(&1 == x1)) == nil
    end)
  end

  @tag timeout: 100_000
  test "set_balance_r performs ~ Pr[I(b) > sqrt(4mln(n))] < 2/n" do
    n_subjects = 1000
    n_features = 50
    objective = :math.sqrt(4 * n_subjects * :math.log(n_features))

    {features, subjects} = set_balance_data(n_features, n_subjects)

    {test, _control} = Algorex.set_balance_r(subjects)

    c = Enum.map(subjects, fn s -> if s in test, do: 1, else: -1 end)

    imbalance =
      features
      |> Enum.map(&LinearAlgebra.dot(&1, c))
      |> Enum.map(&Kernel.abs/1)
      |> Enum.max()

    assert imbalance < objective
  end
end
