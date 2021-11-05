defmodule HolidayTest do
  use ExUnit.Case
  doctest Holiday

  test "check for empty database" do
    assert Holiday.init_db() != nil
  end

  test "holiday check today" do
    assert Holiday.is_holiday() == false
  end

  test "holiday check new year" do
    assert Holiday.is_holiday(~D[2022-01-01]) == true
  end

  test "check time to 26.10.2021 in days" do
    dt = %DateTime{
      year: 2021,
      month: 10,
      day: 26,
      zone_abbr: "AMT",
      hour: 0,
      minute: 0,
      second: 0,
      utc_offset: -14400,
      std_offset: 0,
      time_zone: "America/Manaus"
    }

    assert Holiday.time_until_holiday(dt, "second") == 1_368_000
  end

  test "check time to 26.10.2021 in hour" do
    dt = %DateTime{
      year: 2021,
      month: 10,
      day: 26,
      zone_abbr: "AMT",
      hour: 0,
      minute: 0,
      second: 0,
      utc_offset: -14400,
      std_offset: 0,
      time_zone: "America/Manaus"
    }

    assert Holiday.time_until_holiday(dt, "minute") == 22800
  end

  test "check time to 26.10.2021 in minute" do
    dt = %DateTime{
      year: 2021,
      month: 10,
      day: 26,
      zone_abbr: "AMT",
      hour: 0,
      minute: 0,
      second: 0,
      utc_offset: -14400,
      std_offset: 0,
      time_zone: "America/Manaus"
    }

    assert Holiday.time_until_holiday(dt, "hour") == 380
  end

  test "check time to 26.10.2021 in second" do
    dt = %DateTime{
      year: 2021,
      month: 10,
      day: 26,
      zone_abbr: "AMT",
      hour: 0,
      minute: 0,
      second: 0,
      utc_offset: -14400,
      std_offset: 0,
      time_zone: "America/Manaus"
    }

    assert trunc(Holiday.time_until_holiday(dt, "day")) == 15
  end
end
