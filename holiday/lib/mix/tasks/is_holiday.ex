defmodule Mix.Tasks.Holiday do
  use Mix.Task

  @shortdoc "Simply calls the Hello.say/0 function."
  def run(_) do
    # calling our Hello.say() function from earlier
    if Holiday.is_holiday(Holiday.init_db()) do
      IO.puts("yes")
    else
      IO.puts("no")
    end
  end
end
