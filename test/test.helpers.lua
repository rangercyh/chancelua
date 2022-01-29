local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

local tip = 'capitalize() works as expected'
Helper.times_f(function()
    local word = chance:capitalize(chance:word())
    assert(type(word) == "string", tip)
    assert(string.find(word, "%u+"), tip)
end, 10)

tip = 'n() gives an array of n terms for the given function'
local arr = chance:n(chance.email, chance, 25, { domain = "example.com" })
assert(type(arr) == "table", tip)
assert(#arr == 25, tip)
for _, v in pairs(arr) do
    assert(string.find(v, "example%.com"), tip)
end

tip = 'n() gives an array of 1 when n not given'
local arr = chance:n(chance.email, chance)
assert(type(arr) == "table", tip)
assert(#arr == 1, tip)

tip = 'n() throws when first argument is not a function'
assert(not(pcall(chance.n, self, "foo", 10)), tip)
assert(not(pcall(chance.n, self, {}, 10)), tip)
assert(not(pcall(chance.n, self, nil, 10)), tip)
assert(not(pcall(chance.n, self, 21, 10)), tip)
assert(not(pcall(chance.n, self, chance:character({ pool = "abcde" }), 10)), tip)

tip = 'n() gives an empty array when n is set to 0'
local arr = chance:n(chance.email, chance, 0)
assert(type(arr) == "table", tip)
assert(#arr == 0, tip)

tip = 'pick() returns a single element when called without a count argument'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pick(arr)
    assert(string.len(picked) == 1, tip)
end)

tip = 'pick() returns a multiple elements when called with a count argument'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pick(arr, 3)
    assert(#picked == 3, tip)
end)

tip = 'pick() does not destroy the original array'
local arr = { "a", "b", "c", "d", "e", "f" }
Helper.times_f(function()
    local cloned = Helper.clone(arr)
    local picked = chance:pick(cloned, 3)
    assert(#cloned == 6, tip)
    for k, v in ipairs(cloned) do
        assert(v == arr[k], tip)
    end
end)

tip = 'pick() throws if zero elements in array'
local fn = function()
    chance:pick({})
end
assert(not(pcall(fn)), tip)

tip = 'pickone() returns a single element'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pickone(arr)
    assert(string.len(picked) == 1, tip)
    assert(type(picked) ~= "table", tip)
end)

tip = 'pickone() throws if zero elements in array'
local fn = function()
    chance:pickone({})
end
assert(not(pcall(fn)), tip)
--[[
tip = 'pickset() returns empty array when count 0'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pickset(arr, 0)
    assert(#picked == 0, tip)
    assert(type(picked) == "table", tip)
end)

tip = 'pickset() throws if zero elements in array'
local fn = function()
    chance:pickset({})
end
assert(not(pcall(fn)), tip)

tip = 'pickset() returns single element array if no count provided'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pickset(arr)
    assert(#picked == 1, tip)
    assert(type(picked) == "table", tip)
end)

tip = 'pickset() throws if count is not positive number'
local arr = { "a", "b", "c", "d" }
local fn = function()
    chance:pickset(arr, -1)
end
assert(not(pcall(fn)), tip)

tip = 'pickset() returns single element array when called with count of 1'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pickset(arr, 1)
    assert(#picked == 1, tip)
    assert(type(picked) == "table", tip)
end)

tip = 'pickset() returns multiple elements when called with count > 1'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pickset(arr, 3)
    assert(#picked == 3, tip)
    assert(type(picked) == "table", tip)
end)

tip = 'pickset() returns no more values than the size of the array'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pickset(arr, 5)
    assert(#picked == 4, tip)
end)

tip = 'pickset() does not destroy the original array'
local arr = { "a", "b", "c", "d", "e", "f" }
Helper.times_f(function()
    local cloned = Helper.clone(arr)
    local picked = chance:pickset(cloned, 3)
    assert(#cloned == 6, tip)
    for k, v in ipairs(cloned) do
        assert(v == arr[k], tip)
    end
end)

tip = 'pickset() returns unique values'
local arr = { "a", "b", "c", "d" }
Helper.times_f(function()
    local picked = chance:pickset(arr, 4)
    for i = 1, #arr do
        local find = false
        for _, v in pairs(picked) do
            if arr[i] == v then
                find = true
                break
            end
        end
        assert(find, tip)
    end
end)
]]
tip = 'shuffle() returns an array of the same size'
local arr = { "a", "b", "c", "d", "e" }
Helper.times_f(function()
    local cloned = Helper.clone(arr)
    local shuffled = chance:shuffle(cloned)
    assert(#shuffled == 5, tip)
    local find = false
    for k, v in ipairs(shuffled) do
        if v == "a" then
            find = true
            break
        end
    end
    assert(find, tip)
end)

tip = 'shuffle() returns a well shuffled array'
-- See http://vq.io/1lEhbim checking it isn't doing that!
local arr = { "a", "b", "c", "d", "e" }
local positions = {
    a = { 0, 0, 0, 0, 0 },
    b = { 0, 0, 0, 0, 0 },
    c = { 0, 0, 0, 0, 0 },
    d = { 0, 0, 0, 0, 0 },
    e = { 0, 0, 0, 0, 0 },
}
local shuffled = Helper.clone(arr)
Helper.times_f(function()
    local shuffled = chance:shuffle(shuffled)
    for k, v in ipairs(shuffled) do
        -- Accumulate the position of the item each time
        positions[v][k] = positions[v][k] + 1
    end
end, 10000)
for k, v in pairs(positions) do
    for m, n in ipairs(v) do
        -- This should be around 50% give or take a bit since there are
        -- 5 elements and they should be evenly distributed
        assert(n >= 1500 and n <= 2500, tip)
    end
end

tip = 'shuffle() does not destroy original array'
local arr = { "a", "b", "c", "d", "e" }
Helper.times_f(function()
    local cloned = Helper.clone(arr)
    local shuffled = chance:shuffle(cloned)
    assert(#shuffled == 5, tip)
    for k, v in ipairs(cloned) do
        assert(v == arr[k], tip)
    end
end)

--[=[
tip = 'unique() gives a unique array of the selected function'
Helper.times_f(function()
    local arr = chance:unique(chance.character, chance, 25, { pool = "abcdefghijklmnopqrstuvwxyz" })
    assert(type(arr) == "table", tip)
    local map = {}
    local n = 0
    for _, c in pairs(arr) do
        if not(map[c]) then
            n = n + 1
            map[c] = true
        end
    end
    assert(n == 25, tip)
end)

tip = 'unique() works properly with options'
Helper.times_f(function()
    local arr = chance:unique(chance.date, chance, 20, { year = 2016 })
    assert(type(arr) == "table", tip)
    local map = {}
    local n = 0
    for _, c in pairs(arr) do
        if not(map[c]) then
            n = n + 1
            map[c] = true
        end
    end
    assert(n == 20, tip)
end)

tip = 'unique() throws when num is likely out of range'
local fn = function()
    chance:unique(chance.character, chance, 10, { pool = "abcde" })
end
assert(not(pcall(fn)), tip)

tip = 'unique() throws when first argument is not a function'
local fn = function()
    chance:unique(chance:character({ pool = "abcde" }), 10)
end
assert(not(pcall(fn)), tip)

tip = 'unique() will take a custom comparator for comparing complex objects'
local comparator = function(arr, val)
    -- If this is the first element, we know it doesn't exist
    if #arr == 0 then
        return false
    else
        -- If a match has been found, short circuit check and just return
        local acc = false
        for i = 1, #arr do
            acc = acc and acc or arr[i].name == val.name
        end
        return acc
    end
end
local arr = chance:unique(chance.currency, chance, 25, { comparator = comparator })
local map = {}
local n = 0
for _, c in pairs(arr) do
    if not(map[c]) then
        n = n + 1
        map[c] = true
    end
end
assert(n == 25, tip)

tip = 'unique() works without a third argument'
Helper.times_f(function()
    local u = chance:unique(chance,character, chance, 10)
    assert(type(u) == "table", tip)
end)
]=]
tip = 'weighted() returns an element'
Helper.times_f(function()
    local picked = chance:weighted({ 'a', 'b', 'c', 'd' }, { 1, 1, 1, 1 })
    assert(type(picked) == "string", tip)
    assert(string.len(picked) == 1, tip)
end)

tip = 'weighted() works with just 2 items'
--[[
Use Math.random as the random function rather than our Mersenne twister
just tospeed things up here because this test takes awhile to gather
enough data to have a large enough sample size to adequately test. This
increases speed by a few orders of magnitude at the cost of
repeatability (which we aren't using here)
]]
local chance = Chance.new(math.random)
local picked = { a = 0, b = 0 }
-- This makes it a tad slow, but we need a large enough sample size to adequately test
Helper.times_f(function()
    local r = chance:weighted({ "a", "b" }, { 1, 100 })
    picked[r] = picked[r] + 1
end, 50000)
-- This range is somewhat arbitrary, but good enough to test our constraints
local ratio = picked.b / picked.a
assert(ratio > 80 and ratio < 120, tip)

tip = 'weighted() works with trim'
Helper.times_f(function()
    local picked = chance:weighted({ 'a', 'b', 'c', 'd' }, { 1, 1, 1, 1 }, true)
    assert(type(picked) == "string", tip)
    assert(string.len(picked) == 1, tip)
end)

tip = 'weighted() throws error if called with an array of weights different from options'
local fn = function()
    chance:weighted({ 'a', 'b', 'c', 'd' }, { 1, 2, 3 })
end
assert(not(pcall(fn)), tip)

tip = 'weighted() does not throw error if called with good weights'
local fn = function()
    chance:weighted({ 'a', 'b', 'c', 'd' }, { 1, 2, 3, 4 })
end
assert(pcall(fn), tip)

tip = 'weighted() throws error if weights invalid'
local fn = function()
    chance:weighted({ 'a', 'b', 'c', 'd' }, { 0, 0, 0, 0 })
end
assert(not(pcall(fn)), tip)

tip = 'weighted() throws error if called with an array of weights different from options 2'
local fn = function()
    chance:weighted({ 'a', 'b', 'c', 'd' }, { 1, 2, 3, 4, 5 })
end
assert(not(pcall(fn)), tip)

tip = 'weighted() throws error if weights contains NaN'
local fn = function()
    chance:weighted({ 'a', 'b', 'c', 'd' }, { 1, nil, 1, 1 })
end
assert(not(pcall(fn)), tip)

tip = 'weighted() returns results properly weighted'
--[[
Use Math.random as the random function rather than our Mersenne twister
just tospeed things up here because this test takes awhile to gather
enough data to have a large enough sample size to adequately test. This
increases speed by a few orders of magnitude at the cost of
repeatability (which we aren't using here)
]]
local chance = Chance.new(math.random)
local picked = { a = 0, b = 0, c = 0, d = 0 }
Helper.times_f(function()
    local r = chance:weighted({ 'a', 'b', 'c', 'd' }, { 1, 100, 100, 1 })
    picked[r] = picked[r] + 1
end, 50000)
-- This range is somewhat arbitrary, but good enough to test our constraints
local baRatio = picked.b / picked.a
assert(baRatio > 60 and baRatio < 140, tip)
local cdRatio = picked.c / picked.d
assert(cdRatio > 60 and cdRatio < 140, tip)
local cbRatio = (picked.c / picked.b) * 100
assert(cbRatio > 50 and cbRatio < 150, tip)

tip = 'weighted() works with fractional weights'
--[[
Use Math.random as the random function rather than our Mersenne twister
just tospeed things up here because this test takes awhile to gather
enough data to have a large enough sample size to adequately test. This
increases speed by a few orders of magnitude at the cost of
repeatability (which we aren't using here)
]]
local chance = Chance.new(math.random)
local picked = { a = 0, b = 0, c = 0, d = 0 }
Helper.times_f(function()
    local r = chance:weighted({ 'a', 'b', 'c', 'd' }, { 0.001, 0.1, 0.1, 0.001 })
    picked[r] = picked[r] + 1
end, 50000)
-- This range is somewhat arbitrary, but good enough to test our constraints
local baRatio = picked.b / picked.a
assert(baRatio > 60 and baRatio < 140, tip)
local cdRatio = picked.c / picked.d
assert(cdRatio > 60 and cdRatio < 140, tip)
local cbRatio = (picked.c / picked.b) * 100
assert(cbRatio > 50 and cbRatio < 150, tip)

tip = 'weighted() works with weight of 0'
Helper.times_f(function()
    local picked = chance:weighted({ "a", "b", "c" }, { 1, 0, 1 })
    assert(type(picked) == "string", tip)
    assert(picked ~= "b", tip)
end)

tip = 'weighted() works with negative weight'
Helper.times_f(function()
    local picked = chance:weighted({ "a", "b", "c" }, { 1, -2, 1 })
    assert(type(picked) == "string", tip)
    assert(picked ~= "b", tip)
end)

tip = 'pad() always returns same number when width same as length of number'
Helper.times_f(function()
    local num = chance:natural({ min = 10000, max = 99999 })
    local padded = chance:pad(num, 5)
    assert(type(padded) == "string", tip)
    assert(string.len(padded) == 5, tip)
end)

tip = 'pad() will pad smaller number to the right width'
Helper.times_f(function()
    local num = chance:natural({ max = 99999 })
    local padded = chance:pad(num, 10)
    assert(type(padded) == "string", tip)
    assert(string.len(padded) == 10, tip)
    assert(string.find(padded, "00000"), tip)
end)

tip = 'pad() can take a pad e.lement'
Helper.times_f(function()
    local num = chance:natural({ max = 99999 })
    local padded = chance:pad(num, 10, "V")
    assert(type(padded) == "string", tip)
    assert(string.len(padded) == 10, tip)
    assert(string.find(padded, "VVVVV"), tip)
end)

print("-------->>>>>>>> helpers test ok <<<<<<<<--------", os.clock() - t1)
