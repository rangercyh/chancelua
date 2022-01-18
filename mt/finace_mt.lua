local mt = {}

function mt:cc()
end
function mt:cc_types()
end
function mt:cc_type()
end
-- return all world currency by ISO 4217
function mt:currency_types()
end
-- return random world currency by ISO 4217
function mt:currency()
end
-- return all timezones available
function mt:timezones()
end
-- return random timezone
function mt:timezone()
end
-- Return random correct currency exchange pair (e.g. EUR/USD) or array of currency code
function mt:currency_pair()
end
function mt:dollar()
end
function mt:euro()
end
function mt:exp()
end
function mt:exp_month()
end
function mt:exp_year()
end
function mt:vat()
end
--[[
Generate a string matching IBAN pattern (https://en.wikipedia.org/wiki/International_Bank_Account_Number).
No country-specific formats support (yet)
]]
function mt:iban()
end

return mt
