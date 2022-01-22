local Helper = require "utils.helper"
local Chance = require "chance"

local chance = Chance.new()
local tip = "returns a random boolean"
local bool = chance:bool()
assert(type(bool) == "boolean", tip)

tip = "bool() is within the bounds of what we would call random"
local true_count = 0
Helper.thousand_times_f(function()
    if chance:bool() then
        true_count = true_count + 1
    end
end)
-- The probability of this test failing is approximately 4.09e-86.
-- So, in theory, it could give a false negative, but the sun will
-- probably die long before that happens.
assert(true_count > 200 and true_count < 800, tip)

tip = "bool() takes and obeys likelihood"
true_count = 0
for i = 1, 1000 do
    if chance:bool({ likelihood = 30 }) then
        true_count = true_count + 1
    end
end
-- Expect it to average around 300
assert(true_count > 200 and true_count < 400, tip)
true_count = 0
Helper.thousand_times_f(function()
    if chance:bool({ likelihood = 99 }) then
        true_count = true_count + 1
    end
end)
-- Expect it to average at 990
assert(true_count > 900, tip)

tip = "bool() throws an error if likelihood < 0 or > 100"
assert(not pcall(chance.bool, chance, {likelihood = -23}), tip)
assert(not pcall(chance.bool, chance, {likelihood = 7933}), tip)

tip = "Chance() does return differing results if differing seeds provided"
local chance1 = Chance.new(12345)
local chance2 = Chance.new(54321)
assert(chance1:random() ~= chance2:random(), tip)

tip = "Chance() returns repeatable results if seed provided on the Chance object"
local seed = os.time()
local chance1 = Chance.new(seed)
local chance2 = Chance.new(seed)
Helper.thousand_times_f(function()
    assert(chance1:random() == chance2:random(), tip)
end)

tip = "Chance() returns repeatable results if a string is provided as a seed"
local seed = "foo"
local chance1 = Chance.new(seed)
local chance2 = Chance.new(seed)
Helper.thousand_times_f(function()
    assert(chance1:random() == chance2:random(), tip)
end)

tip = "Chance() returns different results if two different strings are provided"
local chance1 = Chance.new("foo")
local chance2 = Chance.new("baz")
Helper.thousand_times_f(function()
    assert(chance1:random() ~= chance2:random(), tip)
end)

tip = 'Chance() returns different results if two different strings are provided redux'
-- Credit to @dan-tilley for noticing this flaw in the old seed
local chance1 = Chance.new("abe")
local chance2 = Chance.new("acc")
Helper.thousand_times_f(function()
    assert(chance1:random() ~= chance2:random(), tip)
end)

tip = 'Chance() returns different results if multiple arguments are provided'
local seed = os.time()
local chance1 = Chance.new(seed, "foo")
local chance2 = Chance.new(seed, "bar")
Helper.thousand_times_f(function()
    assert(chance1:random() ~= chance2:random(), tip)
end)

tip = 'Chance() will take an arbitrary function for the seed and use it'
local chance = Chance.new(function() return 123 end)
Helper.thousand_times_f(function()
    assert(chance:random() == 123, tip)
end)

chance = Chance.new()

tip = 'animal() return a animal'
assert(type(chance:animal()) == "string", tip)
assert(type(chance:animal({ type = "desert" })) == "string", tip)
local fn = function()
    chance:animal({ type = "a" })
end
assert(not(pcall(fn)), tip)

tip = 'character() returns a character'
local char = chance:character()
assert(type(char) == "string", tip)
assert(string.len(char) == 1, tip)
tip = 'character() pulls only from pool, when specified'
Helper.thousand_times_f(function()
    local char = chance:character({ pool = "abcde"})
    assert(string.match(char, "[abcde]") == char, tip)
end)

tip = 'character() allows only alpha'
Helper.thousand_times_f(function()
    local char = chance:character({ alpha = true })
    assert(string.match(char, "[a-zA-Z]") == char, tip)
end)

tip = 'character() allows only alphanumeric'
Helper.thousand_times_f(function()
    local char = chance:character({ alpha = true, numeric = true })
    assert(string.match(char, "[a-zA-Z0-9]") == char, tip)
end)

tip = 'character() obeys upper case'
Helper.thousand_times_f(function()
    local char = chance:character({ alpha = true, casing = "upper" })
    assert(string.match(char, "[A-Z]") == char, tip)
end)
tip = 'character() obeys lower case'
Helper.thousand_times_f(function()
    local char = chance:character({ alpha = true, casing = "lower" })
    assert(string.match(char, "[a-z]") == char, tip)
end)

tip = 'floating() returns a random floating'
assert(math.type(chance:floating()) == "float", tip)

tip = 'floating() can take both a max and min and obey them both'
Helper.thousand_times_f(function()
    local floating = chance:floating({ min = 90, max = 100 })
    assert(floating > 89 and floating < 101, tip)
end)

tip = 'floating() will not take fixed + min that would be out of range'
local fn = function()
    chance:floating({ fixed = 13, min = -9007199254740992 })
end
assert(not(pcall(fn)), tip)

tip = 'floating() will not take fixed + max that would be out of range'
local fn = function()
    chance:floating({ fixed = 13, max = 9007199254740992 })
end
assert(not(pcall(fn)), tip)
tip = 'floating() obeys the fixed parameter, when present'
Helper.thousand_times_f(function()
    local floating = chance:floating({ fixed = 4 })
    floating = tostring(floating)
    assert(string.len(floating) - (string.find(floating, "%.")) < 5, tip)
end)
tip = 'floating() can take fixed and obey it'
Helper.thousand_times_f(function()
    local floating = chance:floating({ fixed = 3 })
    floating = tostring(floating)
    assert(string.len(floating) - (string.find(floating, "%.")) <= 3, tip)
end)

tip = 'hex() works as expected'
Helper.thousand_times_f(function()
    local hex = chance:hex()
    assert(string.match(hex, "[0-9a-f]+") == hex, tip)
end)

tip = 'hex() can take Upper and obey it'
Helper.thousand_times_f(function()
    local hex = chance:hex({ casing = 'upper' })
    assert(string.match(hex, "[0-9A-F]+") == hex, tip)
end)

tip = 'integer() returns a random integer'
assert(math.type(chance:integer()) == "integer", tip)

tip = 'integer() is sometimes negative, sometimes positive'
local positive_count = 0
Helper.thousand_times_f(function()
    if chance:integer() > 0 then
        positive_count = positive_count + 1
    end
end)
-- Note: In very extreme circumstances this test may fail as, by its
-- nature it's random. But it's a low enough percentage that I'm
-- willing to accept it.
assert(positive_count > 200 and positive_count < 800, tip)

tip = 'integer() can take a zero min and obey it'
Helper.thousand_times_f(function()
    assert(chance:integer({ min = 0 }) > 0, tip)
end)

tip = 'integer() can take a negative min and obey it'
Helper.thousand_times_f(function()
    assert(chance:integer({ min = -25 }) > -26, tip)
end)

tip = 'integer() can take a negative min and max and obey both'
Helper.thousand_times_f(function()
    local integer = chance:integer({ min = -25, max = -1 })
    assert(integer > -26 and integer < 0, tip)
end)

tip = 'integer() can take a min with absolute value less than max and return in range above'
local count = 0
Helper.thousand_times_f(function()
    -- With a range this large we'd expect most values to be
    -- greater than 1 if this works correctly.
    if math.abs(chance:integer({ min = -1, max = 1000000 })) < 2 then
        count = count + 1
    end
end)
assert(count < 900, tip)

tip = 'integer() throws an error when min > max'
local fn = function()
    chance:integer({ min = 1000, max = 500 })
end
assert(not(pcall(fn)), tip)

tip = 'letter() returns a letter'
Helper.thousand_times_f(function()
    local letter = chance:letter()
    assert(type(letter) == "string", tip)
    assert(string.len(letter) == 1, tip)
    assert(string.match(letter, "[a-z]") == letter, tip)
end)

tip = 'letter() can take upper case'
Helper.thousand_times_f(function()
    local letter = chance:letter({ casing = "upper" })
    assert(type(letter) == "string", tip)
    assert(string.len(letter) == 1, tip)
    assert(string.match(letter, "[A-Z]") == letter, tip)
end)

tip = 'natural() returns a random natural'
assert(math.type(chance:natural()) == "integer", tip)

tip = 'natural() throws an error if min < 0'
local fn = function()
    chance:natural({min = - 23})
end
assert(not(pcall(fn)), tip)

tip = 'natural() is always positive or zero'
local positive_count = 0
Helper.thousand_times_f(function()
    if chance:natural() >= 0 then
        positive_count = positive_count + 1
    end
end)
assert(positive_count == 1000, tip)

tip = 'natural() can take just a min and obey it'
Helper.thousand_times_f(function()
    assert(chance:natural({ min = 9007199254740991 }) > 9007199254740990, tip)
end)

tip = 'natural() can take just a max and obey it'
Helper.thousand_times_f(function()
    assert(chance:natural({ max = 100 }) < 101, tip)
end)

tip = 'natural() can take both a max and min and obey them both'
Helper.thousand_times_f(function()
    local natural = chance:natural({ min = 90, max = 100 })
    assert(natural > 89 and natural < 101, tip)
end)

tip = 'natural() works with both bounds 0'
Helper.thousand_times_f(function()
    assert(chance:natural({ min = 0, max = 0 }) == 0, tip)
end)

tip = 'natural() respects numerals'
Helper.thousand_times_f(function()
    local natural = chance:natural({ numerals = 2 })
    assert(natural <= 99 and natural >= 10, tip)
end)

tip = 'natural() works with excluded numbers'
Helper.thousand_times_f(function()
    local natural = chance:natural({ min = 1, max = 5, exclude = { 1, 3 } })
    assert(natural <= 5 and natural >= 1 and natural ~= 1 and natural ~= 3, tip)
end)

tip = 'natural() works within empty exclude option'
Helper.thousand_times_f(function()
    local natural = chance:natural({ min = 1, max = 5, exclude = {} })
    assert(natural <= 5 and natural >= 1, tip)
end)

tip = 'natural() throws an error if exclude is not an array'
local fn = function()
    chance:natural({ min = 1, max = 5, exclude = "foo" })
end
assert(not(pcall(fn)), tip)

tip = 'natural() throws an error if exclude is not an array'
local fn = function()
    chance:natural({ min = 1, max = 5, exclude = { "puppies", 1 } })
end
assert(not(pcall(fn)), tip)

tip = 'natural() throws an error if min > max'
local fn = function()
    chance:natural({ min = 1000, max = 500 })
end
assert(not(pcall(fn)), tip)

tip = 'natural() throws an error if numerals is less than 1'
local fn = function()
    chance:natural({ numerals = 0 })
end
assert(not(pcall(fn)), tip)

tip = 'prime() returns a number'
assert(math.type(chance:prime()) == "integer", tip)

tip = 'prime() throws an error if min < 0'
local fn = function()
    chance:prime({ min = -23 })
end
assert(not(pcall(fn)), tip)

tip = 'prime() throws an error if min > max'
local fn = function()
    chance:prime({ min = 1000, max = 500 })
end
assert(not(pcall(fn)), tip)

tip = 'prime() is always positive and odd (or 2)'
local positive_count = 0
Helper.thousand_times_f(function()
    local prime = chance:prime()
    if prime > 0 and (prime % 2 == 1 or prime == 2) then
        positive_count = positive_count + 1
    end
end)
assert(positive_count == 1000, tip)

tip = 'prime() can take just a min and obey it'
Helper.thousand_times_f(function()
    assert(chance:prime({min = 5000}) >= 5000, tip)
end)

tip = 'prime() can take just a max and obey it'
Helper.thousand_times_f(function()
    assert(chance:prime({max = 20000}) <= 20000, tip)
end)

tip = 'prime() can take both a max and min and obey them both'
Helper.thousand_times_f(function()
    local prime = chance:prime({ min = 90, max = 100 })
    assert(prime >= 90 and prime <= 100, tip)
end)

tip = 'set() works as expected'
local cdata = { lastNames = {'customName', 'testLast'} }
chance:set(cdata)
local data = chance:get('lastNames')
assert(type(data) == "table" and #data == 2, tip)

tip = 'string() returns a string'
assert(type(chance:string() == "string"), tip)

tip = 'string() obeys length, when specified'
Helper.thousand_times_f(function()
    local length = chance:natural({ min = 1, max = 25 })
    assert(string.len(chance:string({ length = length })) == length, tip)
end)

tip = 'string() throws error if length < 0'
local fn = function()
    chance:string({ length = -23 })
end
assert(not(pcall(fn)), tip)

tip = 'string() returns only letters with alpha'
Helper.thousand_times_f(function()
    local str = chance:string({ alpha = true })
    assert(string.match(str, "[a-zA-Z]+") == str, tip)
end)

tip = 'string() obeys upper case'
Helper.thousand_times_f(function()
    local str = chance:string({ alpha = true, casing = "upper" })
    assert(string.match(str, "[A-Z]+") == str, tip)
end)

tip = 'string() obeys lower case'
Helper.thousand_times_f(function()
    local str = chance:string({ alpha = true, casing = "lower" })
    assert(string.match(str, "[a-z]+") == str, tip)
end)

tip = 'string() obeys symbol'
Helper.thousand_times_f(function()
    local str = chance:string({ symbols = true })
    assert(string.match(str, "[%!%@%#%$%%%^%&%*%(%)%[%]]+") == str, tip)
end)

tip = 'string() can take just a min and obey it'
Helper.thousand_times_f(function()
    assert(string.len(chance:string({ min = 6 })) >= 6, tip)
end)

tip = 'string() can take just a max and obey it'
Helper.thousand_times_f(function()
    assert(string.len(chance:string({ max = 20 })) <= 20, tip)
end)

tip = 'falsy() should return a falsy value'
Helper.thousand_times_f(function()
    local v = chance:falsy()
    if type(v) == "table" then
        assert(#v == 0, tip)
    else
        assert(v == false or v == "" or v == 0 or v == nil, tip)
    end
end)

tip = 'falsy() should return a falsy value using a pool data'
Helper.thousand_times_f(function()
    local v = chance:falsy({ pool = { nil, 0 } })
    assert(v == nil or v == 0, tip)
end)

tip = 'template() returns alpha numeric substituted'
Helper.thousand_times_f(function()
    local str = chance:template('ID-{Aa}-{##}')
    assert(string.match(str, "ID%-[A-Z][a-z]%-[0-9][0-9]") == str, tip)
end)

tip = 'template() rejects unknown tokens'
local fn = function(t)
    chance:template(t)
end
assert(not(pcall(fn, "{Aa-}")), tip)
assert(not(pcall(fn, "{Aa{}")), tip)
assert(not(pcall(fn, "{Aab}")), tip)

tip = 'template() allows escape sequnce'
assert(chance:template("\\\\ID-\\{Aa\\}") == "\\ID-{Aa}", tip)

tip = 'template() rejects invalid escape sequnce'
assert(not(pcall(fn, "ID-\\Aa")), tip)

tip = 'template() cannot be undefined'
assert(not(pcall(fn)), tip)

tip = 'template() cannot be empty'
assert(not(pcall(fn, "")), tip)

print("-------->>>>>>>> basics test ok <<<<<<<<--------")
