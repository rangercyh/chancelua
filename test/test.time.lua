local Helper = require "utils.helper"
local Chance = require "chance"

local chance = Chance.new()
local tip = 'ampm() returns am or pm'
Helper.times_f(function()
    local ampm = chance:ampm()
    assert(type(ampm) == "string", tip)
    assert(string.match(ampm, "^[ap]m$") == ampm, tip)
end)

tip = 'date() returns a random date'
Helper.times_f(function()
    local date = chance:date()
    assert(type(date) == "table", tip)
end)

tip = 'date() can have some default provided and obey them'
Helper.times_f(function()
    -- One of each month type in terms of number of days.
    local month = { 1, 2, 4 }
    month = month[math.random(1, #month)]
    local date = chance:date({ year = 1983 })
    assert(type(date) == "table", tip)
    assert(date.year == 1983, tip)
    date = chance:date({ month = month })
    assert(type(date) == "table", tip)
    assert(date.month == month, tip)
    date = chance:date({ day = 21 })
    assert(type(date) == "table", tip)
    assert(date.day == 21, tip)
end)

tip = 'date() can specify min and max'
Helper.times_f(function()
    local bounds = {
        min = os.time(),
        max = os.time() + 12345678901,
    }
    local date = chance:date(bounds)
    assert(type(date) == "table", tip)
    local time = os.time(date)
    assert(time >= bounds.min and time <= bounds.max, tip)
end)

tip = 'date() returns a date, can specify just min'
Helper.times_f(function()
    local bounds = {
        min = os.time(),
    }
    local date = chance:date(bounds)
    assert(type(date) == "table", tip)
    local time = os.time(date)
    assert(time >= bounds.min, tip)
end)

tip = 'date() returns a date, can specify just max'
Helper.times_f(function()
    local bounds = {
        max = os.time(),
    }
    local date = chance:date(bounds)
    assert(type(date) == "table", tip)
    local time = os.time(date)
    assert(time <= bounds.max, tip)
end)

tip = 'date() can return a string date'
Helper.times_f(function()
    local date = chance:date({ str = true })
    assert(type(date) == "string", tip)
    assert(string.match(date, "%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d$") == date, tip)
end)

tip = 'hour() returns an hour'
Helper.times_f(function()
    local hour = chance:hour()
    assert(type(hour) == "number", tip)
    assert(hour >= 1 and hour <= 12, tip)
end)

tip = 'hour() returns an hour in 24 hour format'
Helper.times_f(function()
    local hour = chance:hour({ twenty_four = true })
    assert(type(hour) == "number", tip)
    assert(hour >= 0 and hour <= 23, tip)
end)

tip = 'hour() returns an hour, can specify min and max'
Helper.times_f(function()
    local hour = chance:hour({ min = 7, max = 10 })
    assert(type(hour) == "number", tip)
    assert(hour >= 7 and hour <= 10, tip)
end)

tip = 'hour() returns an hour, can specify just min'
Helper.times_f(function()
    local hour = chance:hour({ min = 7 })
    assert(type(hour) == "number", tip)
    assert(hour >= 7 and hour <= 12, tip)
end)

tip = 'hour() returns an hour, can specify just max'
Helper.times_f(function()
    local hour = chance:hour({ max = 10 })
    assert(type(hour) == "number", tip)
    assert(hour >= 1 and hour <= 10, tip)
end)

tip = 'minute() returns a minute'
Helper.times_f(function()
    local minute = chance:minute()
    assert(type(minute) == "number", tip)
    assert(minute >= 0 and minute <= 59, tip)
end)

tip = 'minute() returns an minute, can specify min and max'
Helper.times_f(function()
    local minute = chance:minute({ min = 10, max = 35 })
    assert(type(minute) == "number", tip)
    assert(minute >= 10 and minute <= 35, tip)
end)

tip = 'minute() returns an minute, can specify just min'
Helper.times_f(function()
    local minute = chance:minute({ min = 5 })
    assert(type(minute) == "number", tip)
    assert(minute >= 5 and minute <= 59, tip)
end)

tip = 'minute() returns an minute, can specify just max'
Helper.times_f(function()
    local minute = chance:minute({ max = 32 })
    assert(type(minute) == "number", tip)
    assert(minute >= 0 and minute <= 32, tip)
end)

tip = 'month() returns a month'
Helper.times_f(function()
    local month = chance:month()
    assert(type(month) == "string", tip)
end)

tip = 'month() will return a raw month'
Helper.times_f(function()
    local month = chance:month({ raw = true })
    assert(type(month) == "table", tip)
end)

tip = 'month() returns a month, can specify min and max'
Helper.times_f(function()
    local month = chance:month({ raw = true, min = 5, max = 10 })
    assert(type(month) == "table", tip)
    assert(tonumber(month.numeric) >= 5 and tonumber(month.numeric) <= 10, tip)
end)

tip = 'month() returns a month, can specify just min'
Helper.times_f(function()
    local month = chance:month({ raw = true, min = 5 })
    assert(type(month) == "table", tip)
    assert(tonumber(month.numeric) >= 5 and tonumber(month.numeric) <= 12, tip)
end)

tip = 'month() returns a month, can specify just max'
Helper.times_f(function()
    local month = chance:month({ raw = true, max = 7 })
    assert(type(month) == "table", tip)
    assert(tonumber(month.numeric) >= 1 and tonumber(month.numeric) <= 7, tip)
end)

tip = 'timestamp() returns a timestamp'
Helper.times_f(function()
    local timestamp = chance:timestamp()
    assert(type(timestamp) == "number", tip)
    assert(timestamp <= tonumber(os.time()), tip)
end)

tip = 'weekday() will return a weekday as a string'
Helper.times_f(function()
    local weekday = chance:weekday()
    assert(type(weekday) == "string", tip)
end)

tip = 'weekday() can take work: true and obey it'
Helper.times_f(function()
    local weekday = chance:weekday({ weekday_only = true })
    assert(type(weekday) == "string", tip)
    assert(weekday ~= "Saturday" and weekday ~= "Sunday", tip)
end)

tip = 'year() returns a year, default between today and a century after'
Helper.times_f(function()
    local year = chance:year()
    assert(type(year) == "string", tip)
    local date = os.date("*t")
    assert(tonumber(year) >= date.year and tonumber(year) <= date.year + 100, tip)
end)

tip = 'year() returns a year, can specify min and max'
Helper.times_f(function()
    local year = chance:year({ min = 2500, max = 2600 })
    assert(type(year) == "string", tip)
    assert(tonumber(year) >= 2500 and tonumber(year) <= 2600, tip)
end)

tip = 'year() returns a year, can specify just min'
Helper.times_f(function()
    local year = chance:year({ min = 2500 })
    assert(type(year) == "string", tip)
    assert(tonumber(year) >= 2500, tip)
end)

tip = 'year() returns a year, can specify just max'
Helper.times_f(function()
    local year = chance:year({ max = 2500 })
    assert(type(year) == "string", tip)
    assert(tonumber(year) <= 2501 and tonumber(year) >= 0, tip)
end)

print("-------->>>>>>>> time test ok <<<<<<<<--------")
