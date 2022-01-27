local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

local tip = 'cf() returns a valid random cf'
Helper.times_f(function()
    local cf = chance:cf()
    assert(type(cf) == "string", tip)
    assert(string.len(cf) == 16, tip)
    assert(string.match(cf, "%u%u%u%u%u%u%d%d%u%d%d%u%d%d%d%u") == cf, tip)
end)

tip = 'pl_nip() returns a valid NIP number'
Helper.times_f(function()
    local nip = chance:pl_nip()
    assert(type(nip) == "string", tip)
    assert(string.len(nip) == 10, tip)
end)

tip = 'pl_pesel() returns a valid PESEL number'
Helper.times_f(function()
    local pesel = chance:pl_pesel()
    assert(type(pesel) == "string", tip)
    assert(string.len(pesel) == 11, tip)
end)

tip = 'pl_regon() returns a valid REGON number'
Helper.times_f(function()
    local regon = chance:pl_regon()
    assert(type(regon) == "string", tip)
    assert(string.len(regon) == 9, tip)
end)

print("-------->>>>>>>> regional test ok <<<<<<<<--------", os.clock() - t1)
