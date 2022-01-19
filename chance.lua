local MersenneTwister = require "mersenne_twister"
local BlueImpMD5 = require "blueimp_md5"

local mt = {}
mt.__index = mt

local inject_mt = function(dst, dir, name)
    local src = require(string.format("%s.%s_mt", dir, name))
    for k, v in pairs(src) do
        assert(not dst[k], k)
        dst[k] = v
    end
end

inject_mt(mt, "mt", "basics")
inject_mt(mt, "mt", "helpers")
inject_mt(mt, "mt", "text")
inject_mt(mt, "mt", "person")
inject_mt(mt, "mt", "mobile")
inject_mt(mt, "mt", "web")
inject_mt(mt, "mt", "location")
inject_mt(mt, "mt", "time")
inject_mt(mt, "mt", "finace")
inject_mt(mt, "mt", "regional")
inject_mt(mt, "mt", "music")
inject_mt(mt, "mt", "misc")

function mt:mersenne_twister(seed)
    return MersenneTwister.new(seed)
end
function mt:blueimp_md5()
    return BlueImpMD5.new()
end

local hash_seed = function(str)
    local len = string.len(str)
    local hash = 0
    for i = 1, len do
        hash = string.byte(str, i) + (hash << 6) + (hash << 16) - hash
    end
    return hash
end

local _VERSION = "1.1.8"
local M = {}
function M.new(...)
    local chance = setmetatable({
        VERSION = _VERSION,
    }, mt)
    local num = select('#', ...)
    local seed_init
    if num == 1 then
        local st = type(...)
        if st == "function" then    -- if user has provided a function, use that at the generator
            chance.random = ...
            return chance
        elseif st == "number" then
            seed_init = math.tointeger(st)
        else
            seed_init = hash_seed(tostring(...))
        end
    elseif num > 1 then -- multiple word provide
        seed_init = 0
        for i, v in ipairs({...}) do
            seed_init = seed_init + (num - i - 1) * hash_seed(tostring(v))
        end
    end

    local r = chance:mersenne_twister(seed_init)
    chance.bimd5 = chance:blueimp_md5()
    chance.random = function()
        return r:random()
    end
    return chance
end
return M
