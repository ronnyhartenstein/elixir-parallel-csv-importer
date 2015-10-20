defmodule CsvImporter.Mixfile do
  use Mix.Project

  def project do
    [app: :csv_importer,
     version: "0.1.0",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: escript_config,
     default_task: "import",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [:logger]
    ]
  end

  defp deps do
    [
      #{:csv, "~> 1.1.0"},
      {:faker, "~> 0.5"},
      #{:poolboy, "~> 1.5"}
      {:parallel_stream, "~> 0.1.0"}
    ]
  end


  defp escript_config do
    [ main_module: CsvImporter ]
  end
end
