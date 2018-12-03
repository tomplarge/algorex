defmodule Algorex do

  @spec seed() :: :undefined | tuple
  def seed() do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.strong_rand_bytes(12)

    :sfmt.seed(a,b,c)
  end

  @spec uniform() :: float
  def uniform(), do: :sfmt.uniform

  @spec uniform(integer) :: integer
  def uniform(n), do: :sfmt.uniform(n)

  @spec bernoulli() :: integer
  def bernoulli(), do: uniform(2) - 1

  @spec bernoulli(integer | tuple) :: list | any
  def bernoulli(n) when is_number(n), do: Enum.map(1..n, fn _ -> bernoulli() end)
  def bernoulli(b) when is_tuple(b), do: elem(b, bernoulli())

  @spec bernoulli(integer, tuple) :: [any]
  def bernoulli(n, b) when is_tuple(b) and is_number(n) do
    Enum.map(1..n, fn _ -> bernoulli(b) end)
  end

  # reference: https://en.wikipedia.org/wiki/Set_balancing
  # Best used for large feature sets
  @spec set_balance_r(list) :: {list, list}
  def set_balance_r(subjects) when is_list(subjects) do
    seed()

    result =
      Enum.reduce(subjects, %{0 => [], 1 => []}, fn s, acc ->
        Map.update!(acc, bernoulli(), &[s | &1])
      end)

    {result[0], result[1]}
  end
end
