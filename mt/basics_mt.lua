local helper = require "utils.helper"

local mt = {}

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
    options = helper.init_options(options, {pool = {false, nil, 0, {}, ''}})
    local pool = options.pool
    return pool[self:integer({min = 1, max = #pool})]
end

function mt:animal(options)
    -- returns a random animal
    options = helper.init_options(options)
    if options.type then
        -- if user does not put in a valid animal type, user will get an error
        local ltype = string.lower(options.type)
        assert(self:get("animals")[ltype],
            "Please pick from desert, ocean, grassland, forest, zoo, pets, farm.")
        -- if user does put in valid animal type, will return a random animal of that type
        return self:pick(self:get("animals")[ltype])
    end
    -- if user does not put in any animal type, will return a random animal regardless
    local animal_type = {"desert","forest","ocean","zoo","farm","pet","grassland"}
    return self:pick(self:get("animals")[self:pick(animal_type)])
end

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
    local index = self:natural({max = string.len(pool)})
    return pool:sub(index, index)
end

function mt:floating(options)
    options = helper.init_options(options, {fixed = 4})
    local INT_MAX = math.tointeger(2 ^ 32)
    local fixed = math.floor(10 ^ options.fixed)
    local max = INT_MAX / fixed
    local min = -max

    assert(not(options.min and options.fixed and options.min < min),
        "Chance: Min specified is out of range with fixed. Min should be, at least, " .. min)
    assert(not(options.max and options.fixed and options.max > max),
        "Chance: Max specified is out of range with fixed. Max should be, at most, " .. max)
    options = helper.init_options(options, { min = min, max = max })

    local num = self:integer({min = options.min * fixed, max = options.max * fixed})
    num = num / fixed
    return math.floor(num * 10 ^ options.fixed) / 10 ^ options.fixed
end

function mt:integer(options)
    options = helper.init_options(options, {min = helper.INT_MIN, max = helper.INT_MAX})
    assert(options.min <= options.max, "Chance: Min cannot be greater than Max.")
    return math.floor(self:random() * (options.max - options.min + 1) + options.min)
end

function mt:natural(options)
    options = helper.init_options(options, {min = 1, max = helper.INT_MAX})
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

function mt:prime(options)
    options = helper.init_options(options, { min = 0, max = 10000 })
    assert(options.min >= 0, "Chance: Min cannot be less than zero.")
    assert(options.min <= options.max, "Chance: Min cannot be greater than Max.")
    local prime_data = self:get("primes")
    local last_prime = prime_data[#prime_data]
    if options.max > last_prime then
        for i = last_prime + 2, options.max do
            if helper.is_prime(i) then
                prime_data[#prime_data + 1] = i
            end
        end
    end
    local target_primes = {}
    for _, v in pairs(prime_data) do
        if v >= options.min and v <= options.max then
            target_primes[#target_primes + 1] = v
        end
    end
    return self:pick(target_primes)
end

function mt:hex(options)
    options = helper.init_options(options, { min = 0, max = helper.INT_MAX, casing = "lower" })
    assert(options.min >= 0, "Chance: Min cannot be less than zero.")
    local integer = self:natural({ min = options.min, max = options.max })
    if options.casing == "upper" then
        return string.format("%X", integer)
    end
    return string.lower(string.format("%X", integer))
end

function mt:letter(options)
    options = helper.init_options(options, {casing = "lower"})
    local pool = "abcdefghijklmnopqrstuvwxyz"
    local letter = self:character({pool = pool})
    if options.casing == "upper" then
        letter = string.upper(letter)
    end
    return letter
end

function mt:string(options)
    options = helper.init_options(options, { min = 5, max = 20 })
    if not(options.length) then
        options.length = self:natural({ min = options.min, max = options.max })
    end
    assert(options.length >= 0, "Chance: Length cannot be less than zero.")
    return table.concat(self:n(self.character, self, options.length, options))
end

function mt:template(template)
    if not template or string.len(template) == 0 then
        assert(false, "Template string is required")
    end
    local temp = helper.parse_templates(template)
    local r = {}
    for k, v in ipairs(temp) do
        r[k] = v:substitute(self)
    end
    return table.concat(r)
end

return mt
