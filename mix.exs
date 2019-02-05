defmodule JSONMomoa.MixProject do
  use Mix.Project

  #######
  # API #
  #######

  def application() do
    [
      extra_applications: [:logger],
      mod: {JSONMomoa.Application, []}
    ]
  end

  def project() do
    [
      app: :json_momoa,
      deps: deps(),
      description: description(),
      # feel free to submit pull request w/ lower Elixir version 
      elixir: "~> 1.8",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end

  ###########
  # Private #
  ###########

  defp deps() do
    [
      # static analysis
      {:dialyxir, "~> 1.0.0-rc.4", only: [:dev], runtime: false},
      # document generation
      {:ex_doc, ">= 0.0.0", only: [:dev]}
    ]
  end

  defp description() do
    "A streaming JSON parser/encoder written in pure Elixir."
  end

  defp package() do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/amorphid/json_momoa"}
    ]
  end
end
