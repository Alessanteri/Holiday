defmodule HolidayTest do
  use ExUnit.Case

  test "check for empty database" do
    assert Holiday.init_db() != nil
  end

  test "holiday check today" do
    assert Holiday.is_holiday(Holiday.init_db()) == false
  end

  test "holiday check new year" do
    assert Holiday.is_holiday(Holiday.init_db(), ~D[2021-01-01]) == true
  end

  test "check time to 16.10" do
    dt = %DateTime{
      year: 2021,
      month: 10,
      day: 16,
      zone_abbr: "AMT",
      hour: 0,
      minute: 0,
      second: 0,
      utc_offset: -14400,
      std_offset: 0,
      time_zone: "America/Manaus"
    }

    assert Holiday.time_until_holiday(Holiday.init_db(), dt, "day") == 15
  end
end
