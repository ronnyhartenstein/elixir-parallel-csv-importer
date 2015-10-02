defmodule CsvImporter do
  require Logger

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    case parse do
      {[help: true], _, _} -> :help
      {_, [file], _} -> {file}
      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage:  issues <file>
    """
    System.halt(0)
  end

  def process({file}) do
    Logger.info "verarbeite #{file} .."
    File.stream!(file)
    # das Modul ist scheiße langsam mit 100k Input-Daten
    #|> CSV.decode([separator: ?;]) # Std: :num_pipes 8
    |> Stream.map(&split_row/1)
    # TODO auf 1-8 Prozesse verteilen
    # TODO je Prozess validierung ca. 50ms
    |> Enum.map(&store_row/1)
    #|> Stream.map(&store_row/1)
    #|> Enum.take(1000)
  end

  def split_row(row) do
    String.split(row,";")
  end

  def store_row([id | _]) when id == "id" do
    Logger.debug "skip headers"
  end
  def store_row(data) do
    # TODO aus erste-Zeile holen
    headers = [:id, :first, :last, :company]
    row = Enum.zip(headers, data)
    Logger.debug "data #{data} -> #{row}"
    sql_insert row
  end

  def sql_insert(set) do
    "INSERT INTO table SET "
      <> Enum.map_join(set, ", ", fn({col, val}) -> "#{col}='#{val}'" end)
      <> ";"
    #IO.inspect sql
    #IO.write "."
  end
end
