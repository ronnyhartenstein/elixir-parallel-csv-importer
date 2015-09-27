defmodule Mix.Tasks.Generate do
  use Mix.Task
  require Logger
  require Faker.Name
  require Faker.Company

  @shortdoc "Generiert CSV Daten für Tests"

  def run([file, num_rows]) when is_binary(file) do
    true = String.ends_with? file, ".csv"
    {num_rows,_} = Integer.parse(num_rows)
    Mix.shell.info "generiere #{num_rows} CSV-Daten in #{file}"

    # Zeitmessung ist fummelig
    # https://groups.google.com/forum/#!topic/elixir-lang-core/lhxQyTLzN0Y
    # http://www.erlang.org/doc/man/timer.html#now_diff-2
    ts = :erlang.timestamp
    generate_csv(file, num_rows)
    time = :timer.now_diff(:erlang.timestamp, ts)
    Mix.shell.info "Zeit: #{time/1_000_000}s"
  end

  def run(args) do
    IO.inspect(args)
    Mix.shell.error "Aufruf: mix generate <datei> <num_rows>"
  end

  def generate_csv(file, num_rows) do
    Faker.start

    file
    |> File.open([:write])
    |> write_csv_rows(num_rows)
    |> File.close
  end

  defp write_csv_rows({:ok, file}, num_rows) do
    for n <- 1..num_rows, f <- [file], do: write_row(f,n)
    file
  end

  def write_row(file, num) do
    #Logger.debug "##{num}"
    if num == 1, do: write_header(file)
    row = get_faker_data_row(num) |> generate_row
    Logger.debug "row: #{row}"
    IO.puts file, row
  end

  defp write_header(file) do
    row = Enum.join(["id","first_name","last_name","company_name"], ";")
    IO.puts file, row
  end

  defp get_faker_data_row(num) do
    [ num, Faker.Name.first_name, Faker.Name.last_name, Faker.Company.name ]
  end

  @doc """
  Generiert eine Zeile für die Test-CSV
  ## Example
    iex> Mix.Tasks.Generate.generate_row(["1","a","b"])
    "1;a;b"
  """
  def generate_row(data) do
    # format = row_format(Enum.count(data))
    # :io.format(format, data)
    Enum.join(data,";")
  end

  # @doc """
  # Erzeugt eine Formatvorschrift für `:io.format` anhand einer Anzahl Spalten.
  # ## Example
  #     iex> Mix.Tasks.Generate.row_format(3)
  #     "~s;~s;~s"
  # """
  # def row_format(num_cols) do
  #   Enum.map_join(1..num_cols, ";", fn _ -> "~s" end)
  # end
end
