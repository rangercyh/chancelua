local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

tip = 'android_id() returns a proper android id'
local format = "APA91"
for i = 1, 178 do
    format = format .. "[%d%u%l%-_]"
end
Helper.times_f(function()
    local id = chance:android_id()
    assert(string.match(id, format) == id, tip)
end, 10)

tip = 'apple_token() returns a proper apple push token'
format = ""
for i = 1, 64 do
    format = format .. "[%da-fA-F]"
end
Helper.times_f(function()
    local apple_token = chance:apple_token()
    assert(string.match(apple_token, format) == apple_token, tip)
end, 10)

tip = 'wp8_anid2() returns a proper windows phone 8 anid2'
format = "^"
for i = 1, 43 do
    format = format .. "[%d%u%l]"
end
format = format .. "=$"
Helper.times_f(function()
    local wp8_anid2 = chance:wp8_anid2()
    assert(string.match(wp8_anid2, format) == wp8_anid2, tip)
end, 10)

tip = 'wp7_anid() returns a proper windows phone 7 anid'
format = "^A="
for i = 1, 32 do
    format = format .. "[%dA-F]"
end
format = format .. "&E=[%da-f][%da-f][%da-f]&W=%d$"
Helper.times_f(function()
    local wp7_anid = chance:wp7_anid()
    assert(string.match(wp7_anid, format) == wp7_anid, tip)
end, 10)

tip = 'bb_pin() returns a proper blackberry pin'
format = ""
for i = 1, 8 do
    format = format .. "[%da-f]"
end
Helper.times_f(function()
    local bb_pin = chance:bb_pin()
    assert(string.match(bb_pin, format) == bb_pin, tip)
end, 10)

print("-------->>>>>>>> mobile test ok <<<<<<<<--------", os.clock() - t1)
