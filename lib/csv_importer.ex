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

    File.stream!(file)
    |> Stream.map(&split_row/1)
    |> ParallelStream.map(&store_row/1)  # parallele Verarbeitung
    #|> Stream.map(&store_row/1)  # synchrone Verarbeitung
    |> Enum.into([])

    #:timer.sleep(10_000)
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
    #Logger.debug "data #{data} -> #{row}"
    sql_insert row
  end

  def sql_insert(row) do
    #Logger.debug "Worker handle call #{from} #{state}"
    "INSERT INTO table SET "
      <> Enum.map_join(row, ", ", fn({col, val}) -> "#{col}='#{val}'" end)
      <> ";"
    result = :ok
    #:timer.sleep(Enum.random(50..100))
    :timer.sleep(10)
    #IO.inspect sql

    #{:id, id} = Enum.at(row,0)
    #IO.write ".#{id}"

    #IO.write "."
    :ok
  end
end
