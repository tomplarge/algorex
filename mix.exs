defmodule Algorex.MixProject do
  use Mix.Project

  def project do
    [
      app: :algorex,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_deps: :apps_direct, plt_add_apps: [:sfmt]],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:numerix, :gen_stage, :flow],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc3", only: [:dev], runtime: false},
      {:numerix, "~> 0.5"},
      {:sfmt_erlang, app: false, git: "https://github.com/jj1bdx/sfmt-erlang.git"}
    ]
  end

  defp aliases do
    [
      dialyzer: ["dialyzer --halt-exit-status"],
      lint: ["credo list"]
    ]
  end
end
