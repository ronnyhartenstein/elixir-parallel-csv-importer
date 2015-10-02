defmodule CsvImporter do
  require Logger

  def main(argv) do
    :random.seed(:os.timestamp)
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
    queue = File.stream!(file)
    # das Modul ist scheiße langsam mit 100k Input-Daten
    #|> CSV.decode([separator: ?;]) # Std: :num_pipes 8
    |> Stream.map(&split_row/1)
    |> Enum.map(&store_row/1)
    #|> Stream.map(&store_row/1)
    #|> Enum.take(1000)
    IO.puts "done queueing"
    #IO.inspect queue
    #queue |> Enum.map(&await_ok/1)
    #IO.puts "done awaiting"
  end

  def await_ok(task) do
    case task do
      :ok -> :ok
      #{:ok, _} -> :ok
      _ -> Task.await(task)
    end
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

    # syncrone Verarbeitung
    sql_insert(row)
    # parallele Verarbeitung
    #IO.write "+"
    #Task.async(fn -> sql_insert(row) end)
  end

  def sql_insert(set) do
    "INSERT INTO table SET "
      <> Enum.map_join(set, ", ", fn({col, val}) -> "#{col}='#{val}'" end)
      <> ";"
    :timer.sleep(Enum.random(50..100))
    #IO.inspect sql
    #IO.write "."
  end
end
