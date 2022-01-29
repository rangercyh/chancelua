local helper = require "utils.helper"
local data   = require "utils.data"

local mt = {}

-- Coin - Flip, flip, flipadelphia
function mt:coin()
    return self:bool() and "heads" or "tails"
end

-- Dice - For all the board game geeks out there
function mt:d4()
    return self:natural({ min = 1, max = 4 })
end

function mt:d6()
    return self:natural({ min = 1, max = 6 })
end

function mt:d8()
    return self:natural({ min = 1, max = 8 })
end

function mt:d10()
    return self:natural({ min = 1, max = 10 })
end

function mt:d12()
    return self:natural({ min = 1, max = 12 })
end

function mt:d20()
    return self:natural({ min = 1, max = 20 })
end

function mt:d30()
    return self:natural({ min = 1, max = 30 })
end

function mt:d100()
    return self:natural({ min = 1, max = 100 })
end

function mt:rpg(thrown, options)
    options = helper.init_options(options)
    assert(thrown, "Chance: A type of die roll must be included")
    local bits = helper.split(string.lower(thrown), "d")
    local rolls = {}
    if #bits ~= 2 or not(tonumber(bits[1], 10)) or not(tonumber(bits[2], 10)) then
        assert(false, "Chance: Invalid format provided. Please provide #d#\
            where the first # is the number of dice to roll, the second # is\
             the max of each die")
    end
    for i = bits[1], 1, -1 do
        rolls[i] = self:natural({ min = 1, max = tonumber(bits[2], 10) })
    end
    if options.sum then
        local sum = 0
        for i = 1, #rolls do
            sum = sum + rolls[i]
        end
        return sum
    else
        return rolls
    end
end

-- Guid
function mt:guid(options)
    options = helper.init_options(options, { version = 5 })
    local guid_pool = "abcdef1234567890"
    local variant_pool = "ab89"
    return self:string({ pool = guid_pool, length = 8 }) .. "-" ..
           self:string({ pool = guid_pool, length = 4 }) .. "-" ..
           -- The Version
           options.version ..
           self:string({ pool = guid_pool, length = 3 }) .. "-" ..
           -- The Variant
           self:string({ pool = variant_pool, length = 1 }) ..
           self:string({ pool = guid_pool, length = 3 }) .. "-" ..
           self:string({ pool = guid_pool, length = 12 })
end

-- Hash
function mt:hash(options)
    options = helper.init_options(options, { length = 40, casing = "lower" })
    local pool = options.casing == "upper" and string.upper(helper.HEX_POOL) or
            helper.HEX_POOL
    return self:string({ pool = pool, length = options.length })
end

function mt:luhn_check(num)
    num = tostring(num)
    local check_digit = tonumber(string.sub(num, -1))
    return check_digit == self:luhn_calculate(string.sub(num, 1, -2))
end

function mt:luhn_calculate(num)
    num = string.reverse(tostring(num))
    local sum, digit = 0
    for i = 1, string.len(num) do
        digit = tonumber(string.sub(num, i, i))
        if i % 2 == 1 then
            digit = digit * 2
            if digit > 9 then
                digit = digit - 9
            end
        end
        sum = sum + digit
    end
    return (sum * 9) % 10
end

--[[
 * #Description:
 * =====================================================
 * Generate random file name with extension
 *
 * The argument provide extension type
 * -> raster
 * -> vector
 * -> 3d
 * -> document
 *
 * If nothing is provided the function return random file name with random
 * extension type of any kind
 *
 * The user can validate the file name length range
 * If nothing provided the generated file name is random
 *
 * #Extension Pool :
 * * Currently the supported extensions are
 *  -> some of the most popular raster image extensions
 *  -> some of the most popular vector image extensions
 *  -> some of the most popular 3d image extensions
 *  -> some of the most popular document extensions
 *
 * #Examples :
 * =====================================================
 *
 * Return random file name with random extension. The file extension
 * is provided by a predefined collection of extensions. More about the extension
 * pool can be found in #Extension Pool section
 *
 * chance.file()
 * => dsfsdhjf.xml
 *
 * In order to generate a file name with specific length, specify the
 * length property and integer value. The extension is going to be random
 *
 * chance.file({length : 10})
 * => asrtineqos.pdf
 *
 * In order to generate file with extension from some of the predefined groups
 * of the extension pool just specify the extension pool category in fileType property
 *
 * chance.file({fileType : 'raster'})
 * => dshgssds.psd
 *
 * You can provide specific extension for your files
 * chance.file({extension : 'html'})
 * => djfsd.html
 *
 * Or you could pass custom collection of extensions by array or by object
 * chance.file({extensions : [...]})
 * => dhgsdsd.psd
 *
 * chance.file({extensions : { key : [...], key : [...]}})
 * => djsfksdjsd.xml
 *
 * @param  [collection] options
 * @return [string]
 *
]]
function mt:file(options)
    local file_options = options or {}
    local fe = self:get("fileExtension")
    -- { 'raster', 'vector', '3d', 'document' }
    local type_range = {}
    for k in pairs(fe) do
        type_range[#type_range + 1] = k
    end
    -- Generate random file name
    local file_name = self:word({ length = file_options.length })
    -- Generate file by specific extension provided by the user
    local file_ex
    if file_options.extension then
        file_ex = file_options.extension
        return file_name .. "." .. file_ex
    end
    -- Generate file by specific extension collection
    if file_options.extensions then
        assert(type(file_options.extensions) == "table",
            "Chance: Extensions must be an Array or Object")
        file_ex = self:pickone(file_options.extensions)
        return file_name .. "." .. file_ex
    end
    -- Generate file extension based on specific file type
    if file_options.file_type then
        local file_type = file_options.file_type
        local check_type = false
        for _, v in pairs(type_range) do
            if v == file_type then
                check_type = true
                break
            end
        end
        assert(check_type, "Chance: Expect file type value to be 'raster', \
            'vector', '3d' or 'document'")
        file_ex = self:pickone(fe[file_type])
        return file_name .. "." .. file_ex
    end
    -- Generate random file name if no extension options are passed
    file_ex = self:pickone(fe[self:pickone(type_range)])
    return file_name .. "." .. file_ex
end

-- Get the data based on key
function mt:get(name)
    return helper.clone(data[name])
end

-- Mac Address
function mt:mac_address(options)
    -- typically mac addresses are separated by ":"
    -- however they can also be separated by "-"
    -- the network variant uses a dot every fourth byte
    options = helper.init_options(options)
    if not(options.separator) then
        options.separator = options.network_version and "." or ":"
    end
    local mac_pool = "ABCDEF1234567890"
    local mac
    if options.network_version then
        mac = table.concat(self:n(self.string, self, 3,
                { pool = mac_pool, length = 4 }), options.separator)
    else
        mac = table.concat(self:n(self.string, self, 6,
                { pool = mac_pool, length = 2 }), options.separator)
    end
    return mac
end

function mt:normal(options)
    options = helper.init_options(options, { mean = 0, dev = 1, pool = {} })
    assert(type(options.pool) == "table", "Chance: The pool option must be a valid array.")
    assert(type(options.mean) == "number", "Chance: Mean (mean) must be a number")
    assert(type(options.dev) == "number", "Chance: Standard deviation (dev) must be a number")
    -- If a pool has been passed, then we are returning an item from that pool,
    -- using the normal distribution settings that were passed in
    if #options.pool > 0 then
        return self:normal_pool(options)
    end
    -- The Marsaglia Polar method
    local mean = options.mean
    local dev = options.dev
    local u, v, s
    repeat
        -- U and V are from the uniform distribution on (-1, 1)
        u = self:random() * 2 - 1
        v = self:random() * 2 - 1
        s = u * u + v * v
    until s < 1
    -- Compute the standard normal variate
    local norm = u * math.sqrt(-2 * math.log(s) / s)
    -- Shape and scale
    return dev * norm + mean
end

function mt:normal_pool(options)
    local performance_counter = 0
    repeat
        local idx = math.floor(0.5 + self:normal({ mean = options.mean, dev = options.dev }))
        if idx < #options.pool and idx >= 0 then
            return options.pool[idx + 1]
        else
            performance_counter = performance_counter + 1
        end
    until performance_counter >= 100
    assert(false, "Chance: Your pool is too small for the given mean and \
        standard deviation. Please adjust.")
end

function mt:radio(options)
    -- Initial Letter (Typically Designated by Side of Mississippi River)
    options = helper.init_options(options, { side = "?" })
    local fl
    local sc = string.lower(options.side)
    if sc == "east" or sc == "e" then
        fl = "W"
    elseif sc == "west" or sc == "w" then
        fl = "K"
    else
        fl = self:character({ pool = "KW" })
    end
    return fl .. self:character({ alpha = true, casing = "upper" }) ..
        self:character({ alpha = true, casing = "upper" }) ..
        self:character({ alpha = true, casing = "upper" })
end

-- Set the data as key and data or the data map
function mt:set(name, values)
    if type(name) == "string" then
        data[name] = values
    else
        for k, v in pairs(name) do
            data[k] = v
        end
    end
end

function mt:tv(options)
    return self:radio(options)
end

-- ID number for Brazil companies
function mt:cnpj()
    local n = self:n(self.natural, self, 8, { max = 9 })
    local d1 = 2 + n[8] * 6 + n[7] * 7 + n[6] * 8 + n[5] * 9 + n[4] * 2 +
        n[3] * 3 + n[2] * 4 + n[1] * 5
    d1 = 11 - (d1 % 11)
    if d1 >= 10 then
        d1 = 0
    end
    local d2 = d1 * 2 + 3 + n[8] * 7 + n[7] * 8 + n[6] * 9 + n[5] * 2 +
        n[4] * 3 + n[3] * 4 + n[2] * 5 + n[1] * 6
    d2 = 11 - (d2 % 11)
    if d2 >= 10 then
        d2 = 0
    end
    return "" .. n[1] .. n[2] .. "." .. n[3] .. n[4] .. n[5] .. "." .. n[6] ..
        n[7] .. n[8] .. "/0001-" .. tostring(d1) .. tostring(d2)
end

function mt:emotion()
    return self:pick(self:get("emotions"))
end

return mt
