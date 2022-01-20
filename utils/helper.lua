local data = require "utils.data"

local clone = function(T)
    local mark = {}
    local function copy_table(t)
        if type(t) ~= 'table' then return t end
        local res = {}
        for k, v in pairs(t) do
            if type(v) == 'table' then
                if not mark[v] then
                    mark[v] = copy_table(v)
                end
                res[k] = mark[v]
            else
                res[k] = v
            end
        end
        return res
    end
    return copy_table(T)
end


local M = {}

-- Random helper functions
function M.init_options(options, defaults)
    options = options or {}
    if defaults then
        for k, v in pairs(defaults) do
            if not(options[k]) then
                options[k] = v
            end
        end
    end
    return options
end

-- Get the data based on key
function M.get(name)
    return clone(data[name])
end

function M.thousand_times_f(f)
    for i = 1, 1000 do
        f()
    end
end

M.CHARS_LOWER = 'abcdefghijklmnopqrstuvwxyz'
M.CHARS_UPPER = string.upper(M.CHARS_LOWER)
M.NUMBERS     = '0123456789'
M.HEX_POOL    = string.format("%s%s", M.NUMBERS, "abcdef")

return M
