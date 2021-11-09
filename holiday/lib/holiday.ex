defmodule Holiday do
  alias Holiday.{Repo, Feast}

  @doc """
  Holidays database initialization
  """
  def init_db() do
    Holiday.Feast.clear_database()

    Enum.each(ICalendar.from_ics(File.read!("calendar.ics")), fn x ->
      cond do
        x.dtstart.month == Date.utc_today().month and x.dtstart.day <= Date.utc_today() ->
          add_date_to_database(
            x.summary,
            create_date(Date.utc_today().year, x.dtstart.month, x.dtstart.day),
            create_date(Date.utc_today().year, x.dtend.month, x.dtend.day)
          )

        x.dtstart.month > Date.utc_today().month ->
          add_date_to_database(
            x.summary,
            create_date(Date.utc_today().year, x.dtstart.month, x.dtstart.day),
            create_date(Date.utc_today().year, x.dtend.month, x.dtend.day)
          )

        true ->
          add_date_to_database(
            x.summary,
            create_date(Date.utc_today().year + 1, x.dtstart.month, x.dtstart.day),
            create_date(Date.utc_today().year + 1, x.dtend.month, x.dtend.day)
          )
      end
    end)
  end

  defp create_date(year, month, day) do
    Date.new!(year, month, day)
  end

  defp add_date_to_database(summary, start_date, end_date) do
    %Holiday.Feast{}
    |> Holiday.Feast.changeset(%{name: summary, dtstart: start_date, dtend: end_date})
    |> Repo.insert()
  end

  @doc """
  Function of checking today for a holiday
  """
  @spec is_holiday(%Date{}) :: boolean
  def is_holiday(day \\ Date.utc_today()) do
    if Holiday.Feast.get_data_for_today(day) == [] do
      false
    else
      true
    end
  end

  @doc """
  The function of calculating the time until the next holiday
  """
  @spec time_until_holiday(%DateTime{}, String) :: Float
  def time_until_holiday(now \\ DateTime.utc_now(), _unit)

  def time_until_holiday(now, "day") do
    calculete_time_to_holiday(Holiday.Feast.get_data(now), now) / 86400
  end

  def time_until_holiday(now, "hour") do
    calculete_time_to_holiday(Holiday.Feast.get_data(now), now) / 3600
  end

  def time_until_holiday(now, "minute") do
    calculete_time_to_holiday(Holiday.Feast.get_data(now), now) / 60
  end

  def time_until_holiday(now, "second") do
    calculete_time_to_holiday(Holiday.Feast.get_data(now), now)
  end

  def calculete_time_to_holiday(db, now) do
    Enum.map(db, fn x ->
      %{dtstart: dtstart} = x
      DateTime.new!(dtstart, ~T[00:00:00], "Etc/UTC")
    end)
    |> Enum.min_by(&abs(DateTime.diff(&1, now)))
    |> DateTime.diff(now)
  end
end
