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

function M.clone(T)
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

local replacers = {
    ["#"] = function(chance)
        return chance:character({ pool = M.NUMBERS })
    end,
    ["A"] = function(chance)
        return chance:character({ pool = M.CHARS_UPPER })
    end,
    ["a"] = function(chance)
        return chance:character({ pool = M.CHARS_LOWER })
    end,
}
local template_mt = {
    escape = function(self)
        if string.find(self.c, "[^{}\\]") then
            assert(false, "Invalid escape sequence: "..self.c)
        end
        return self.c
    end,
    identity = function(self)
        return self.c
    end,
    replace = function(self, chance)
        local replacer = replacers[self.c]
        if not replacer then
            assert(false, "Invalid replacement character: "..self.c)
        end
        return replacer(chance)
    end,
}
local gen_token = function(c, ct)
    local t = {}
    t.c = c
    return setmetatable(t, {
        __index = {
            substitute = template_mt[ct],
        },
    })
end
function M.parse_templates(template)
    local tokens = {}
    local mode = "identity"
    for i = 1, string.len(template) do
        local c = string.sub(template, i, i)
        if mode == "escape" then
            tokens[#tokens + 1] = gen_token(c, mode)
            mode = "identity"
        elseif mode == "identity" then
            if c == "{" then
                mode = "replace"
            elseif c == "\\" then
                mode = "escape"
            else
                tokens[#tokens + 1] = gen_token(c, mode)
            end
        elseif mode == "replace" then
            if c == "}" then
                mode = "identity"
            else
                tokens[#tokens + 1] = gen_token(c, mode)
            end
        end
    end
    return tokens
end

function M.thousand_times_f(f)
    for _ = 1, 1000 do
        f()
    end
end

function M.is_prime(n)
    if n % 1 or n < 2 then
        return false
    end
    if n % 2 == 0 then
        return n == 2
    end
    if n % 3 == 0 then
        return n == 3
    end
    local m = math.sqrt(n)
    for i = 5, m, 6 do
        if n % i == 0 or n % (i + 2) == 0 then
            return false
        end
    end
    return true
end

M.CHARS_LOWER = 'abcdefghijklmnopqrstuvwxyz'
M.CHARS_UPPER = string.upper(M.CHARS_LOWER)
M.NUMBERS     = '0123456789'
M.HEX_POOL    = string.format("%s%s", M.NUMBERS, "abcdef")
M.INT_MAX     = 2^53
M.INT_MIN     = -2^53

return M
