defmodule Holiday do
  @doc """
  Holidays database initialization
  """
  @spec init_db() :: %ICalendar{}
  def init_db() do
    ICalendar.from_ics(File.read!("calendar.ics"))
  end

  @doc """
  Function of checking today for a holiday
  """
  @spec is_holiday(%ICalendar{}, %Date{}) :: boolean
  def is_holiday(db, day \\ Date.utc_today()) do
    if Enum.reduce(db, 0, fn x, acc ->
         %{dtstart: dtstart} = x

         if dtstart.month == day.month and dtstart.day == day.day do
           acc + 1
         else
           acc
         end
       end) == 0 do
      false
    else
      true
    end
  end

  @doc """
  The function of calculating the time until the next holiday
  """
  @spec time_until_holiday(%ICalendar{}, %DateTime{}, String) :: Float
  def time_until_holiday(db, now \\ DateTime.utc_now(), _unit)

  def time_until_holiday(db, now, "day") do
    calculete_time_to_holiday(db, now) / 86400
  end

  def time_until_holiday(db, now, "hour") do
    calculete_time_to_holiday(db, now) / 3600
  end

  def time_until_holiday(db, now, "minute") do
    calculete_time_to_holiday(db, now) / 60
  end

  def time_until_holiday(db, now, "second") do
    calculete_time_to_holiday(db, now)
  end

  defp calculete_time_to_holiday(db, now) do
    Enum.reduce(db, 100_000_000_000, fn x, acc ->
      %{dtstart: dtstart} = x

      dt1 = %DateTime{
        year: now.year,
        month: dtstart.month,
        day: dtstart.day,
        zone_abbr: "AMT",
        hour: dtstart.hour,
        minute: dtstart.minute,
        second: dtstart.second,
        utc_offset: -14400,
        std_offset: 0,
        time_zone: "America/Manaus"
      }

      IO.puts(abs(DateTime.diff(dt1, now)) / 86400)

      min(acc, abs(DateTime.diff(dt1, now)))
    end)
  end
end
