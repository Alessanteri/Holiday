defmodule Holiday do
  @doc """
  Holidays database initialization
  """
  def init_db() do
    Enum.each(ICalendar.from_ics(File.read!("calendar.ics")), fn x ->
      cond do
        x.dtstart.month == Date.utc_today().month and x.dtstart.day > Date.utc_today() ->
          start_holiday =
            Date.new!(
              Date.utc_today().year,
              x.dtstart.month,
              x.dtstart.day
            )

          end_holiday =
            Date.new!(
              Date.utc_today().year,
              x.dtend.month,
              x.dtend.day + 1
            )

          %Holiday.Feast{
            name: x.summary,
            dtstart: start_holiday,
            dtend: end_holiday
          }
          |> Holiday.Feast.sign_up()

        x.dtstart.month > Date.utc_today().month ->
          start_holiday =
            Date.new!(
              Date.utc_today().year,
              x.dtstart.month,
              x.dtstart.day
            )

          end_holiday =
            Date.new!(
              Date.utc_today().year,
              x.dtend.month,
              x.dtend.day + 1
            )

          %Holiday.Feast{
            name: x.summary,
            dtstart: start_holiday,
            dtend: end_holiday
          }
          |> Holiday.Feast.sign_up()

        true ->
          start_holiday =
            Date.new!(
              Date.utc_today().year + 1,
              x.dtstart.month,
              x.dtstart.day
            )

          end_holiday =
            Date.new!(
              Date.utc_today().year + 1,
              x.dtend.month,
              x.dtend.day + 1
            )

          %Holiday.Feast{
            name: x.summary,
            dtstart: start_holiday,
            dtend: end_holiday
          }
          |> Holiday.Feast.sign_up()
      end
    end)
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
  def(time_until_holiday(now \\ DateTime.utc_now(), unit)) do
    db = Holiday.Feast.get_data()

    case unit do
      "day" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
          %{dtstart: dtstart} = x
          dt1 = DateTime.new!(dtstart, ~T[00:00:00], "Etc/UTC")

          if acc > DateTime.diff(dt1, now) / 86400 do
            DateTime.diff(dt1, now) / 86400
          else
            acc
          end
        end)

      "hour" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
          %{dtstart: dtstart} = x
          dt1 = DateTime.new!(dtstart, ~T[00:00:00], "Etc/UTC")

          if acc > DateTime.diff(dt1, now) / 3600 do
            DateTime.diff(dt1, now) / 3600
          else
            acc
          end
        end)

      "minute" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
          %{dtstart: dtstart} = x

          dt1 = DateTime.new!(dtstart, ~T[00:00:00], "Etc/UTC")

          if acc > DateTime.diff(dt1, now) / 60 do
            DateTime.diff(dt1, now) / 60
          else
            acc
          end
        end)

      "second" ->
        Enum.reduce(db, 100_000_000_000_000_000, fn x, acc ->
          %{dtstart: dtstart} = x

          dt1 = DateTime.new!(dtstart, ~T[00:00:00], "Etc/UTC")

          if acc > DateTime.diff(dt1, now) do
            DateTime.diff(dt1, now)
          else
            acc
          end
        end)
    end
  end
end
