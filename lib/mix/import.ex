defmodule Mix.Tasks.Import do
  use Mix.Task

  @shortdoc "Importiert CSV Daten (erzeugt SQLs)"

  def run([file]) when is_binary(file) do
    true = String.ends_with? file, ".csv"
    true = File.exists? file
    Mix.shell.info "importiere CSV-Daten in #{file}"

    ts = :erlang.timestamp
    CsvImporter.main([file])
    time = :timer.now_diff(:erlang.timestamp, ts)
    Mix.shell.info "Zeit: #{time/1_000_000}s"
  end

end
