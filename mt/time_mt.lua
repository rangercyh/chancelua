local helper = require "utils.helper"

local mt = {}

function mt:ampm()
end

function mt:date(options)
    local date
    if options and (options.min or options.max) then
        options = helper.init_options(options, { str = false })
        local min = options.min and options.min or 14400       -- 01/01/70 12:00:00
        local max = options.max and options.max or 8640000000  -- 10/17/43 08:00:00
        date = os.date("*t", self:integer({ min = min, max = max }))
    else
        local m = self:month({ raw = true })
        local days_in_month = m.days
        if options and options.month then
            days_in_month = self:get("months")[(options.month % 12 + 12) % 12].days
        end
        options = helper.init_options(options, {
            year = tonumber(self:year()),
            month = tonumber(m.numeric),
            day = self:natural({ min = 1, max = days_in_month }),
            hour = self:hour({ twenty_four = true }),
            minute = self:minute(),
            second = self:second(),
            str = false,
        })
        date = os.date("*t", os.time({
            year = options.year,
            month = options.month,
            day = options.day,
            hour = options.hour,
            min = options.minute,
            sec = options.second,
        }))
    end
    return options.str and os.date("%Y-%m-%d %H:%M:%S", os.time(date)) or date
end

function mt:hammertime()
end

function mt:hour(options)
    options = helper.init_options(options, {
        min = options and options.twenty_four and 0 or 1,
        max = options and options.twenty_four and 23 or 12,
    })
    assert(options.min >= 0, "Chance: Min cannot be less than 0.")
    if options.twenty_four then
        assert(options.max <= 23,
            "Chance: Max cannot be greater than 23 for twentyfour option.")
    else
        assert(options.max <= 12,
            "Chance: Max cannot be greater than 12.")
    end
    assert(options.min <= options.max, "Chance: Min cannot be greater than Max.")
    return self:natural({ min = options.min, max = options.max })
end

function mt:second(options)
    return self:minute(options)
end

function mt:minute(options)
    options = helper.init_options(options, { min = 0, max = 59 })
    assert(options.min >= 0, "Chance: Min cannot be less than 0.")
    assert(options.max <= 59 , "Chance: Max cannot be greater than 59.")
    assert(options.min <= options.max, "Chance: Min cannot be greater than Max.")
    return self:natural({ min = options.min, max = options.max })
end

function mt:month(options)
    options = helper.init_options(options, { min = 1, max = 12 })
    assert(options.min >= 1, "Chance: Min cannot be less than 1.")
    assert(options.max <= 12, "Chance: Max cannot be greater than 12.")
    assert(options.min <= options.max, "Chance: Min cannot be greater than Max.")
    local month = self:pick(table.move(self:get("months"), options.min, options.max, 1, {}))
    return options.raw and month or month.name
end

function mt:timestamp()
end
function mt:weekday()
end
function mt:year(options)
    -- Default to current year as min if none specified
    options = helper.init_options(options, { min = os.date("*t").year })

    -- Default to one century after current year as max if none specified
    options.max = options.max or options.min + 100

    return tostring(self:natural(options))
end

return mt
