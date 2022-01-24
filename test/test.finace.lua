local Helper = require "utils.helper"
local Chance = require "chance"

local chance = Chance.new()

local tip = 'cc() passes the luhn algorithm'
Helper.thousand_times_f(function()
    local number = chance:cc()
    assert(chance:luhn_check(number), tip)
end)

tip = 'cc() can take a type arg and obey it'
Helper.thousand_times_f(function()
    local typ = chance:cc_type({ raw = true })
    local number = chance:cc({ type = typ.name })
    assert(string.len(number) == typ.length, tip)
end)

tip = 'cc() can take a short_name type arg and obey it'
Helper.thousand_times_f(function()
    local typ = chance:cc_type({ raw = true })
    local number = chance:cc({ type = typ.short_name })
    assert(string.len(number) == typ.length, tip)
end)

tip = 'cc_type() returns a random credit card type'
Helper.thousand_times_f(function()
    assert(type(chance:cc_type()) == "string", tip)
end)

tip = 'cc_type() can take a raw arg and obey it'
Helper.thousand_times_f(function()
    local typ = chance:cc_type({ raw = true })
    assert(typ.name and typ.short_name and typ.prefix and typ.length, tip)
end)

tip = 'cc_type() can take a name arg and obey it'
Helper.thousand_times_f(function()
    local typ = chance:cc_type({ name = "Visa", raw = true })
    assert(typ.name == "Visa", tip)
end)

tip = 'cc_type() with bogus type throws'
local fn = function()
    chance:cc_type({ name = "potato" })
end
assert(not(pcall(fn)), tip)

tip = 'currency() returns a currency'
Helper.thousand_times_f(function()
    local currency = chance:currency()
    assert(type(currency) == "table", tip)
    assert(currency.code and string.len(currency.code) == 3 and currency.name, tip)
end)

tip = 'currency_pair() returns a currency pair'
Helper.thousand_times_f(function()
    local currency_pair = chance:currency_pair()
    assert(type(currency_pair) == "table", tip)
    assert(#currency_pair == 2, tip)
    assert(currency_pair[1].code ~= currency_pair[2].code, tip)
end)

tip = 'currency_pair() can return string version'
Helper.thousand_times_f(function()
    local currency_pair = chance:currency_pair(true)
    assert(type(currency_pair) == "string", tip)
    assert(string.len(currency_pair) == 7, tip)
    assert(string.match(currency_pair, "^[A-Z][A-Z][A-Z]+%/[A-Z][A-Z][A-Z]$") == currency_pair, tip)
end)

tip = 'dollar() returns a proper dollar amount'
Helper.thousand_times_f(function()
    local dollar = chance:dollar()
    assert(string.match(dollar, "%-?%$[0-9]+%.?[0-9]*") == dollar,tip)
    assert(tonumber(string.match(dollar, "[0-9]+%.?[0-9]*")) < 10001, tip)
end)

tip = 'dollar() obeys min and max, if provided'
Helper.thousand_times_f(function()
    local dollar = chance:dollar({ max = 20 })
    assert(tonumber(string.match(dollar, "[0-9]+%.?[0-9]*")) <= 20, tip)
end)

Helper.thousand_times_f(function()
    local dollar = chance:dollar({ min = 20 })
    assert(tonumber(string.match(dollar, "[0-9]+%.?[0-9]*")) >= 20, tip)
end)

tip = 'dollar() can take negative min and max'
Helper.thousand_times_f(function()
    local dollar = chance:dollar({ min = -200, max = -1 })
    assert(string.sub(dollar, 1, 1) == '-', tip)
    local dollar_num = tonumber(string.match(dollar, "[0-9]+%.?[0-9]*"))
    dollar_num = dollar_num * -1
    assert(dollar_num <= -1 and dollar_num >= -200, tip)
end)

tip = 'euro() returns a proper euro amount'
Helper.thousand_times_f(function()
    local euro = chance:euro()
    assert(string.match(euro, "[0-9]+%.?[0-9]+€") == euro, tip)
    assert(tonumber(string.match(euro, "[0-9]+%.?[0-9]*")) < 10001, tip)
end)

tip = 'exp() looks correct'
Helper.thousand_times_f(function()
    local exp = chance:exp()
    assert(type(exp) == "string", tip)
    assert(string.len(exp) == 7, tip)
    assert(string.match(exp, "%d%d%/%d%d%d%d") == exp, tip)
end)

tip = 'exp() will respect object argument'
Helper.thousand_times_f(function()
    local exp = chance:exp({ raw = true })
    assert(type(exp) == "table", tip)
    assert(exp.month and type(exp.month) == "string" and exp.year and type(exp.year) == "string", tip)
end)

tip = 'exp() returs a valid credit card expiration (in a future date)'
Helper.thousand_times_f(function()
    local exp = chance:exp({ raw = true })
    local now = os.date("*t")
    assert(tonumber(exp.year) >= now.year, tip)
    if tonumber(exp.year) == now.year then
        assert(tonumber(exp.month) >= now.month, tip)
    end
end)

tip = 'exp_month() returns a numeric month with leading 0'
Helper.thousand_times_f(function()
    local month = chance:exp_month()
    assert(type(month) == "string", tip)
    assert(string.len(month) == 2, tip)
end)

tip = 'exp_year() returns an expiration year'
Helper.thousand_times_f(function()
    local year = chance:exp_year()
    assert(type(year) == "string", tip)
    year = tonumber(year)
    local cur_year = os.date("*t").year
    assert(year >= cur_year, tip)
    assert(year <= cur_year + 10)
end)

tip = 'exp_month() will return a future month if requested'
Helper.thousand_times_f(function()
    local now_month = os.date("*t").month
    local exp_month = tonumber(chance:exp_month({ future = true }))
    exp_month = tonumber(exp_month)
    if now_month ~= 12 then
        assert(exp_month > now_month, tip)
    else
        assert(exp_month >= 1 and exp_month <= 12, tip)
    end
end)

tip = 'luhn_check() properly checks if number passes the Luhn algorithm'
assert(chance:luhn_check(49927398716), tip)
assert(chance:luhn_check(1234567812345670), tip)
assert(not(chance:luhn_check(49927398717)), tip)
assert(not(chance:luhn_check(1234567812345678)), tip)

tip = 'iban() returns an iban'
Helper.thousand_times_f(function()
    local iban = chance:iban()
    assert(type(iban) == "string", tip)
    assert(string.match(iban, "^%u%u%d%d[%u%d]+%d+") == iban, tip)
end)

chance:timezone()

chance:vat()

print("-------->>>>>>>> finace test ok <<<<<<<<--------")
