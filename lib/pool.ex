defmodule CsvImporterPool do
  use Application
  require Logger

  defp pool_name() do
    :csv_pool
  end

  def start(_type, _args) do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, CsvImporter.Worker},
      {:size, 10},
      {:max_overflow, 1}
    ]

    children = [
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    options = [
      strategy: :one_for_one,
      name: CsvImporterPool.Supervisor
    ]
    Logger.debug "start cowboy supervisor"
    Supervisor.start_link(children, options)
  end

  def add_row(row) do
    spawn( fn() -> process_row(row) end )
  end

  defp process_row(row) do
    IO.write "+"
    :poolboy.transaction(
      pool_name(),
      fn(pid) -> :gen_server.call(pid, row) end,
      :infinity
    )
  end
end
