defmodule CsvImporter.Worker do
  use GenServer
  require Logger

  def start_link([]) do
    Logger.debug "Worker start link"
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(state) do
    Logger.debug "Worker init #{state}"
    {:ok, state}
  end

  def handle_call(row, from, state) do
    Logger.debug "Worker handle call #{from} #{state}"
    "INSERT INTO table SET "
      <> Enum.map_join(row, ", ", fn({col, val}) -> "#{col}='#{val}'" end)
      <> ";"
    result = :ok
    :timer.sleep(Enum.random(50..100))
    #IO.inspect sql
    IO.write "."
    {:reply, [result], state}
  end
end
