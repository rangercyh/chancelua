local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

tip = 'coin() returns a coin'
Helper.times_f(function()
    local coin = chance:coin()
    assert(coin == "heads" or coin == "tails", tip)
end)

tip = 'd4() returns a properly bounded d4'
Helper.times_f(function()
    local die = chance:d4()
    assert(die >= 1 and die <= 4, tip)
end)

tip = 'd6() returns a properly bounded d6'
Helper.times_f(function()
    local die = chance:d6()
    assert(die >= 1 and die <= 6, tip)
end)

tip = 'd8() returns a properly bounded d8'
Helper.times_f(function()
    local die = chance:d8()
    assert(die >= 1 and die <= 8, tip)
end)

tip = 'd10() returns a properly bounded d10'
Helper.times_f(function()
    local die = chance:d10()
    assert(die >= 1 and die <= 10, tip)
end)

tip = 'd12() returns a properly bounded d12'
Helper.times_f(function()
    local die = chance:d12()
    assert(die >= 1 and die <= 12, tip)
end)

tip = 'd20() returns a properly bounded d20'
Helper.times_f(function()
    local die = chance:d20()
    assert(die >= 1 and die <= 20, tip)
end)

tip = 'd30() returns a properly bounded d30'
Helper.times_f(function()
    local die = chance:d30()
    assert(die >= 1 and die <= 30, tip)
end)

tip = 'd100() returns a properly bounded d100'
Helper.times_f(function()
    local die = chance:d100()
    assert(die >= 1 and die <= 100, tip)
end)

tip = 'emotion() returns a random emotion'
Helper.times_f(function()
    local emotion = chance:emotion()
    assert(type(emotion) == "string", tip)
    local len = string.len(emotion)
    assert(len >= 2 and len <= 30, tip)
end)

local add_format = function(n, format, str)
    str = str or "[%da-fA-F]"
    for i = 1, n do
        format = format .. str
    end
    return format
end
tip = 'guid() returns a proper guid'
local format = ""
format = add_format(8, format)
for _ = 1, 3 do
    format = format .. "%-"
    format = add_format(4, format)
end
format = format .. "%-"
format = add_format(12, format)
Helper.times_f(function()
    local guid = chance:guid()
    assert(string.match(guid, format) == guid, tip)
end, 10)

tip = 'guid() returns a proper version 1 guid'
local format = ""
format = add_format(8, format)
format = format .. "%-"
format = add_format(4, format)
format = format .. "%-1"
format = add_format(3, format)
format = format .. "%-[ab89]"
format = add_format(3, format)
format = format .. "%-"
format = add_format(12, format)
Helper.times_f(function()
    local guid = chance:guid({ version = 1 })
    assert(string.match(guid, format) == guid, tip)
end, 10)

tip = 'guid() returns a proper version 2 guid'
local format = ""
format = add_format(8, format)
format = format .. "%-"
format = add_format(4, format)
format = format .. "%-2"
format = add_format(3, format)
format = format .. "%-[ab89]"
format = add_format(3, format)
format = format .. "%-"
format = add_format(12, format)
Helper.times_f(function()
    local guid = chance:guid({ version = 2 })
    assert(string.match(guid, format) == guid, tip)
end, 10)

tip = 'guid() returns a proper version 3 guid'
local format = ""
format = add_format(8, format)
format = format .. "%-"
format = add_format(4, format)
format = format .. "%-3"
format = add_format(3, format)
format = format .. "%-[ab89]"
format = add_format(3, format)
format = format .. "%-"
format = add_format(12, format)
Helper.times_f(function()
    local guid = chance:guid({ version = 3 })
    assert(string.match(guid, format) == guid, tip)
end, 10)

tip = 'guid() returns a proper version 4 guid'
local format = ""
format = add_format(8, format)
format = format .. "%-"
format = add_format(4, format)
format = format .. "%-4"
format = add_format(3, format)
format = format .. "%-[ab89]"
format = add_format(3, format)
format = format .. "%-"
format = add_format(12, format)
Helper.times_f(function()
    local guid = chance:guid({ version = 4 })
    assert(string.match(guid, format) == guid, tip)
end, 10)

tip = 'guid() returns a proper version 5 guid'
local format = ""
format = add_format(8, format)
format = format .. "%-"
format = add_format(4, format)
format = format .. "%-5"
format = add_format(3, format)
format = format .. "%-[ab89]"
format = add_format(3, format)
format = format .. "%-"
format = add_format(12, format)
Helper.times_f(function()
    local guid = chance:guid({ version = 5 })
    assert(string.match(guid, format) == guid, tip)
end, 10)

tip = 'hash() returns a proper hash'
local format = ""
for i = 1, 40 do
    format = format .. "[%da-f]"
end
Helper.times_f(function()
    local hash = chance:hash()
    assert(string.match(hash, format) == hash, tip)
    assert(string.len(hash) == 40, tip)
end, 10)

tip = 'hash() obeys length, if supplied'
Helper.times_f(function()
    local len = chance:natural({ min = 1, max = 64 })
    local hash = chance:hash({ length = len })
    assert(string.len(hash) == len, tip)
end, 10)

tip = 'mac_address() returns a proper mac address'
local format = "[%da-fA-F][%da-fA-F]"
format = add_format(5, format, ":[%da-fA-F][%da-fA-F]")
Helper.times_f(function()
    local mac_address = chance:mac_address()
    assert(string.match(mac_address, format) == mac_address, tip)
end, 10)

tip = 'mac_address() returns a proper colon separated mac address'
local format = "[%da-fA-F][%da-fA-F]"
format = add_format(5, format, ":[%da-fA-F][%da-fA-F]")
Helper.times_f(function()
    local mac_address = chance:mac_address({ separator = ":" })
    assert(string.match(mac_address, format) == mac_address, tip)
end, 10)

tip = 'mac_address() returns a proper hyphen separated mac address'
local format = "[%da-fA-F][%da-fA-F]"
format = add_format(5, format, "%-[%da-fA-F][%da-fA-F]")
Helper.times_f(function()
    local mac_address = chance:mac_address({ separator = "-" })
    assert(string.match(mac_address, format) == mac_address, tip)
end, 10)

tip = 'mac_address() returns a proper network version mac address'
local format = ""
format = add_format(4, format, "[%da-fA-F]")
format = format .. "%."
format = add_format(4, format, "[%da-fA-F]")
format = format .. "%."
format = add_format(4, format, "[%da-fA-F]")
Helper.times_f(function()
    local mac_address = chance:mac_address({ network_version = true })
    assert(string.match(mac_address, format) == mac_address, tip)
end, 10)

tip = 'radio() works as expected'
Helper.times_f(function()
    local radio = chance:radio()
    assert(type(radio) == "string", tip)
    assert(string.len(radio) == 4, tip)
    assert(string.match(radio, "^[KW]%u%u%u") == radio, tip)
end, 10)

tip = 'radio() accepts east'
Helper.times_f(function()
    local radio = chance:radio({ side = "east" })
    assert(type(radio) == "string", tip)
    assert(string.len(radio) == 4, tip)
    assert(string.match(radio, "^[W]%u%u%u") == radio, tip)
end, 10)

tip = 'radio() accepts west'
Helper.times_f(function()
    local radio = chance:radio({ side = "west" })
    assert(type(radio) == "string", tip)
    assert(string.len(radio) == 4, tip)
    assert(string.match(radio, "^[K]%u%u%u") == radio, tip)
end, 10)

tip = 'rpg() appears to work as expected'
Helper.times_f(function()
    local dice = chance:rpg("5d20")
    assert(type(dice) == "table", tip)
    assert(#dice == 5, tip)
    for _, v in pairs(dice) do
        assert(v >= 1 and v <= 20, tip)
    end
end)

tip = 'rpg() without a die roll throws an error'
local fn = function(str)
    chance:rpg(str)
end
assert(not(pcall(fn)), tip)

tip = 'rpg() throws errors where it should'
assert(not(pcall(fn, "3")), tip)
assert(not(pcall(fn, "hd23")), tip)
assert(not(pcall(fn, "3d23d2")), tip)
assert(not(pcall(fn, "d20")), tip)

tip = 'rpg() will take and obey a sum'
Helper.times_f(function()
    local rpg = chance:rpg("4d20", { sum = true })
    assert(type(rpg) == "number", tip)
    assert(rpg >= 4 and rpg <= 80, tip)
end)

tip = 'tv() works as expected'
Helper.times_f(function()
    local tv = chance:tv()
    assert(type(tv) == "string", tip)
    assert(string.len(tv) == 4, tip)
    assert(string.match(tv, "^[KW]%u%u%u") == tv, tip)
end)

print("-------->>>>>>>> misc test ok <<<<<<<<--------", os.clock() - t1)
