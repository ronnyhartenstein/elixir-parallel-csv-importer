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
    |> CSV.decode([separator: ?;]) # Std: :num_pipes 8
    |> Enum.map(&store_row(&1))
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
    IO.write "."
  end
end
