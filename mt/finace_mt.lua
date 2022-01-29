local helper = require "utils.helper"

local mt = {}

function mt:cc(options)
    options = helper.init_options(options)
    local c_type = options.type and
            self:cc_type({ name = options.type, raw = true }) or
            self:cc_type({ raw = true })
    local number = c_type.prefix
    local to_generate = c_type.length - string.len(number) - 1
    -- Generates n - 1 digits
    number = number .. table.concat(self:n(self.integer, self, to_generate, { min = 0, max = 9 }))
    -- Generates the last digit according to Luhn algorithm
    number = number .. self:luhn_calculate(number)
    return number
end

function mt:cc_type(options)
    options = helper.init_options(options)
    local all_types = self:get("cc_types")
    local target
    if options.name then
        for _, v in pairs(all_types) do
            if v.name == options.name or v.short_name == options.name then
                target = v
                break
            end
        end
        assert(target, "cc_types name must exist")
    else
        target = self:pick(all_types)
    end
    return options.raw and target or target.name
end

-- return random world currency by ISO 4217
function mt:currency()
    return self:pick(self:get("currency_types"))
end

-- return random timezone
function mt:timezone()
    return self:pick(self:get("timezones"))
end

-- Return random correct currency exchange pair (e.g. EUR/USD) or array of currency code
-- function mt:currency_pair(return_as_string)
--     local currencies = self:unique(self.currency, self, 2, {
--         comparator = function(arr, val)
--             local ret = false
--             for _, v in ipairs(arr) do
--                 ret = ret or v.code == val.code
--             end
--             return ret
--         end,
--     })
--     if return_as_string then
--         return currencies[1].code .. '/' .. currencies[2].code
--     else
--         return currencies
--     end
-- end

function mt:dollar(options)
    -- By default, a somewhat more sane max for dollar than all available numbers
    options = helper.init_options(options, { max = 10000, min = 0 })
    local dollar = self:floating({ min = options.min, max = options.max, fixed = 2 })
    local dollar_str = tostring(dollar)
    local cents = string.match(dollar_str, "%.(%d+)")
    if not(cents) then
        dollar_str = dollar_str .. ".00"
    elseif string.len(cents) < 2 then
        dollar_str = dollar_str .. '0'
    end
    if dollar < 0 then
        return "-$" .. string.sub(dollar_str, 2)
    else
        return "$" .. dollar_str
    end
end

function mt:euro(options)
    local dollar = self:dollar(options)
    local b = string.find(dollar, "%$")
    return string.sub(dollar, 1, b - 1) .. string.sub(dollar, b + 1) .. "€"
end

function mt:exp(options)
    options = helper.init_options(options)
    local exp = {}
    exp.year = self:exp_year()

    -- If the year is this year, need to ensure month is greater than the
    -- current month or this expiration will not be valid
    if exp.year == os.date("*t").year then
        exp.month = self:exp_month({ future = true })
    else
        exp.month = self:exp_month()
    end
    return options.raw and exp or exp.month .. '/' .. exp.year
end

function mt:exp_month(options)
    options = helper.init_options(options)
    local cur_month = os.date("*t").month
    local month, month_int
    if options.future and cur_month ~= 12 then
        repeat
            month = self:month({ raw = true }).numeric
            month_int = tonumber(month)
        until month_int > cur_month
    else
        month = self:month({ raw = true }).numeric
    end
    return month
end

function mt:exp_year()
    local date = os.date("*t")
    local cur_month = date.month
    local cur_year = date.year
    return self:year({
        min = cur_month == 12 and cur_year + 1 or cur_year,
        max = cur_year + 10
    })
end

function mt:vat(options)
    options = helper.init_options(options, { country = "it" })
    if string.lower(options.country) == "it" then
        return self:it_vat()
    end
end

--[[
Generate a string matching IBAN pattern (https://en.wikipedia.org/wiki/International_Bank_Account_Number).
No country-specific formats support (yet)
]]
function mt:iban()
    local alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    local alphanum = alpha .. '0123456789';
    local iban =
        self:string({ length = 2, pool = alpha }) ..
        self:pad(self:integer({ min = 0, max = 99 }), 2) ..
        self:string({ length = 4, pool = alphanum }) ..
        self:pad(self:natural(), self:natural({ min = 6, max = 26 }))
    return iban
end

return mt
