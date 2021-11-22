defmodule Mix.Tasks.Holiday do
  use Mix.Task

  @shortdoc "The function checks today for a holiday"
  def run(_) do
    if Holiday.is_holiday() do
      IO.puts("yes")
    else
      IO.puts("no")
    end
  end
end
