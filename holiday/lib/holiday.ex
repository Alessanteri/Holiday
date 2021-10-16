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
  def(time_until_holiday(db, now \\ DateTime.utc_now(), unit)) do
    case unit do
      "day" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
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

          if acc > sing(DateTime.diff(dt1, now) / 86400, unit) do
            acc = sing(DateTime.diff(dt1, now) / 86400, unit)
          else
            acc
          end
        end)

      "hour" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
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

          if acc > sing(DateTime.diff(dt1, now) / 3600, unit) do
            acc = sing(DateTime.diff(dt1, now) / 3600, unit)
          else
            acc
          end
        end)

      "minute" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
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

          if acc > sing(DateTime.diff(dt1, now) / 60, unit) do
            acc = sing(DateTime.diff(dt1, now) / 60, unit)
          else
            acc
          end
        end)

      "second" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
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

          if acc > sing(DateTime.diff(dt1, now), unit) do
            acc = sing(DateTime.diff(dt1, now), unit)
          else
            acc
          end
        end)
    end
  end

  def sing(result, unit) when result < 0 and unit == "second", do: 31_536_000 - result
  def sing(result, unit) when result < 0 and unit == "minute", do: 525_600 - result
  def sing(result, unit) when result < 0 and unit == "hour", do: 8760 - result
  def sing(result, unit) when result < 0 and unit == "day", do: 365 - result
  def sing(result, unit) when result >= 0, do: result
end
