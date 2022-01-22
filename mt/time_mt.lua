local helper = require "utils.helper"

local mt = {}

function mt:ampm()
end
function mt:date()
end
function mt:hammertime()
end
function mt:hour()
end
function mt:millisecond()
end
function mt:second()
end
function mt:minute()
end
function mt:month(options)
    options = helper.init_options(options, { min = 1, max = 12 })
    assert(options.min >= 1, "Chance: Min cannot be less than 1.")
    assert(options.max <= 12, "Chance: Max cannot be greater than 12.")
    assert(options.min <= options.max, "Chance: Min cannot be greater than Max.")
    local month = self:pick(table.move(self:get("months"), options.min, options.max, 1, {}))
    return options.raw and month or month.name
end
function mt:second()
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
