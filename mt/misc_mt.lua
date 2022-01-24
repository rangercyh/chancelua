local helper = require "utils.helper"
local data   = require "utils.data"

local mt = {}

-- Coin - Flip, flip, flipadelphia
function mt:coin()
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

function mt:rpg()
end

-- Guid
function mt:guid()
end

-- Hash
function mt:hash()
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

-- MD5 Hash
function mt:md5()
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
function mt:file()
end

-- Get the data based on key
function mt:get(name)
    return helper.clone(data[name])
end

-- Mac Address
function mt:mac_address()
end
function mt:normal()
end
function mt:normal_pool()
end
function mt:radio()
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

function mt:tv()
end

-- ID number for Brazil companies
function mt:cnpj()
end
function mt:emotion()
end

return mt
