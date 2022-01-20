local helper = require "utils.helper"

local mt = {}

--[[
    Return a random bool, either true or false

    @param {Object} [options={ likelihood: 50 }] alter the likelihood of
          receiving a true or false value back.
    @throws {RangeError} if the likelihood is out of bounds
    @returns {Bool} either true or false
]]
function mt:bool(options)
    -- likelihood of success (true)
    options = helper.init_options(options, {likelihood = 50})
    -- Note, we could get some minor perf optimizations by checking range
    -- prior to initializing defaults, but that makes code a bit messier
    -- and the check more complicated as we have to check existence of
    -- the object then existence of the key before checking constraints.
    -- Since the options initialization should be minor computationally,
    -- decision made for code cleanliness intentionally. This is mentioned
    -- here as it's the first occurrence, will not be mentioned again.
    assert(options.likelihood >= 0 and options.likelihood <= 100,
        "Chance: Likelihood accepts values from 0 to 100.")
    return self:random() * 100 < options.likelihood
end

function mt:falsy(options)
    -- return a random falsy value
    options = helper.init_options(options, {pool = {false, nil, 0, {}, '', function() end}})
    local pool = options.pool
    return pool[self:integer({min = 1, max = #pool})]
end

function mt:animal(options)
    -- returns a random animal
    options = helper.init_options(options)
    if options.type then
        -- if user does not put in a valid animal type, user will get an error
        local ltype = string.lower(options.type)
        assert(helper.get("animals")[ltype],
            "Please pick from desert, ocean, grassland, forest, zoo, pets, farm.")
        -- if user does put in valid animal type, will return a random animal of that type
        return self:pick(helper.get("animals")[ltype])
    end
    -- if user does not put in any animal type, will return a random animal regardless
    local animal_type = {"desert","forest","ocean","zoo","farm","pet","grassland"}
    return self:pick(helper.get("animals")[self:pick(animal_type)])
end

--[[
    Return a random character.

    @param {Object} [options ={}] can specify a character pool or alpha,
    numeric, symbols and casing (lower or upper)
    @returns {String} a single random character
]]
function mt:character(options)
    options = helper.init_options(options)
    local symbols = "!@#$%^&*()[]"
    local letters, pool
    if options.casing == "lower" then
        letters = helper.CHARS_LOWER
    elseif options.casing == "upper" then
        letters = helper.CHARS_UPPER
    else
        letters = string.format("%s%s", helper.CHARS_LOWER, helper.CHARS_UPPER)
    end

    if options.pool then
        pool = options.pool
    else
        pool = ""
        if options.alpha then
            pool = string.format("%s%s", pool, letters)
        end
        if options.numeric then
            pool = string.format("%s%s", pool, helper.NUMBERS)
        end
        if options.symbols then
            pool = string.format("%s%s", pool, symbols)
        end
        if string.len(pool) == 0 then
            pool = string.format("%s%s%s", letters, helper.NUMBERS, symbols)
        end
    end
    local index = self:natural({max = {string.len(pool)}})
    return pool:sub(index, index)
end

-- Note, wanted to use "float" or "double" but those are both JS reserved words.

-- Note, fixed means N OR LESS digits after the decimal. This because
-- It could be 14.9000 but in JavaScript, when this is cast as a number,
-- the trailing zeroes are dropped. Left to the consumer if trailing zeroes are
-- needed
--[[
    Return a random floating point number

    @param {Object} [options={}] can specify a fixed precision, min, max
    @returns {Number} a single floating point number
    @throws {RangeError} Can only specify fixed or precision, not both.
        Also min cannot be greater than max
]]
function mt:floating()
end

--[[
    Return a random integer

    NOTE the max and min are INCLUDED in the range. So:
    chance.integer({min: 1, max: 3});
    would return either 1, 2, or 3.

    @param {Object} [options={}] can specify a min and/or max
    @returns {Number} a single random integer number
    @throws {RangeError} min cannot be greater than max
]]
function mt:integer(options)
    options = helper.init_options(options, {min = math.mininteger, max = math.maxinteger})
    assert(options.min <= options.max, "Chance: Min cannot be greater than Max.")
    return math.floor(self:random() * (options.max - options.min + 1) + options.min)
end

--[[
    Return a random natural

    NOTE the max and min are INCLUDED in the range. So:
    chance.natural({min: 1, max: 3});
    would return either 1, 2, or 3.

    @param {Object} [options={}] can specify a min and/or max or a numerals count.
    @returns {Number} a single random integer number
    @throws {RangeError} min cannot be greater than max
]]
function mt:natural(options)
    options = helper.init_options(options, {min = 1, max = math.maxinteger})
    if type(options.numerals) == "number" then
        assert(options.numerals >= 1, "Chance: Numerals cannot be less than one.")
        options.min = 10 ^ (options.numerals - 1)
        options.max = 10 ^ options.numerals - 1
    end
    assert(options.min >= 0, "Chance: Min cannot be less than zero.")
    if options.exclude then
        assert(type(options.exclude) == "table", "Chance: exclude must be an array.")
        for _, v in pairs(options.exclude) do
            assert(math.type(v) == "integer", "Chance: exclude must be numbers.")
        end
        local random = options.min + self:natural({max = options.max - options.min - #options.exclude})
        table.sort(options.exclude)
        for _, v in ipairs(options.exclude) do
            if random < v then
                break
            end
            random = random + 1
        end
        return random
    end
    return self:integer(options)
end

--[[
*  Return a random prime number
     *
     *  NOTE the max and min are INCLUDED in the range.
     *
     *  @param {Object} [options={}] can specify a min and/or max
     *  @returns {Number} a single random prime number
     *  @throws {RangeError} min cannot be greater than max nor negative
]]
function mt:prime()
end
--[[
Determine whether a given number is prime or not.
]]
function mt:is_prime()
end
--[[
*  Return a random hex number as string
     *
     *  NOTE the max and min are INCLUDED in the range. So:
     *  chance.hex({min: '9', max: 'B'});
     *  would return either '9', 'A' or 'B'.
     *
     *  @param {Object} [options={}] can specify a min and/or max and/or casing
     *  @returns {String} a single random string hex number
     *  @throws {RangeError} min cannot be greater than max
]]
function mt:hex()
end
function mt:letter()
end
--[[
*  Return a random string
     *
     *  @param {Object} [options={}] can specify a length or min and max
     *  @returns {String} a string of random length
     *  @throws {RangeError} length cannot be less than zero
]]
function mt:string()
end

--[[
*  Return a random string matching the given template.
     *
     *  The template consists of any number of "character replacement" and
     *  "character literal" sequences. A "character replacement" sequence
     *  starts with a left brace, has any number of special replacement
     *  characters, and ends with a right brace. A character literal can be any
     *  character except a brace or a backslash. A literal brace or backslash
     *  character can be included in the output by escaping with a backslash.
     *
     *  The following replacement characters can be used in a replacement
     *  sequence:
     *
     *      "#": a random digit
     *      "a": a random lower case letter
     *      "A": a random upper case letter
     *
     *  Example: chance.template('{AA###}-{##}')
     *
     *  @param {String} template string.
     *  @returns {String} a random string matching the template.
]]
function mt:template()
end
--[[
*  Return a random buffer
     *
     *  @param {Object} [options={}] can specify a length
     *  @returns {Buffer} a buffer of random length
     *  @throws {RangeError} length cannot be less than zero
]]
function mt:buffer()
end

return mt
