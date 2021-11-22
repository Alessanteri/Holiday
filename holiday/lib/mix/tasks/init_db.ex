defmodule Mix.Tasks.Datebase do
  use Mix.Task

  @shortdoc "Database initialization function."
  def run(_) do
    Holiday.init_db()
  end
end
