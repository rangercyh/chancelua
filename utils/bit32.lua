local function tbl2number(tbl)
    local result = 0
    local power = 1
    for i = 1, #tbl do
        result = result + tbl[i] * power
        power = power * 2
    end
    return result
end

local function expand(t1, t2)
    local big, small = t1, t2
    if #big < #small then
        big, small = small, big
    end
    -- expand small
    for i = #small + 1, #big do
        small[i] = 0
    end
end

local to_bits -- needs to be declared before bit_not

local bit_not = function(n)
    local tbl = to_bits(n)
    local size = math.max(#tbl, 32)
    for i = 1, size do
        if tbl[i] == 1 then
            tbl[i] = 0
        else
            tbl[i] = 1
        end
    end
    return tbl2number(tbl)
end

-- defined as local above
to_bits = function(n)
    if n < 0 then
        -- negative
        return to_bits(bit_not(math.abs(n)) + 1)
    end
    -- to bits table
    local tbl = {}
    local cnt = 1
    local last
    while n > 0 do
        last      = n % 2
        tbl[cnt]  = last
        n         = (n - last)/2
        cnt       = cnt + 1
    end
    return tbl
end

local bit_or = function(m, n)
    local tbl_m = to_bits(m)
    local tbl_n = to_bits(n)
    expand(tbl_m, tbl_n)
    local tbl = {}
    for i = 1, #tbl_m do
        if tbl_m[i] == 0 and tbl_n[i] == 0 then
            tbl[i] = 0
        else
            tbl[i] = 1
        end
    end
    return tbl2number(tbl)
end

local bit_and = function(m, n)
    local tbl_m = to_bits(m)
    local tbl_n = to_bits(n)
    expand(tbl_m, tbl_n)
    local tbl = {}
    for i = 1, #tbl_m do
        if tbl_m[i] == 0 or tbl_n[i] == 0 then
            tbl[i] = 0
        else
            tbl[i] = 1
        end
    end
    return tbl2number(tbl)
end

local bit_xor = function(m, n)
    local tbl_m = to_bits(m)
    local tbl_n = to_bits(n)
    expand(tbl_m, tbl_n)
    local tbl = {}
    for i = 1, #tbl_m do
        if tbl_m[i] ~= tbl_n[i] then
            tbl[i] = 1
        else
            tbl[i] = 0
        end
    end
    return tbl2number(tbl)
end

local bit_rshift = function(n, bits)
    local high_bit = 0
    if n < 0 then
        -- negative
        n = bit_not(math.abs(n)) + 1
        high_bit = 0x80000000
    end
    local floor = math.floor
    for _ = 1, bits do
        n = n / 2
        n = bit_or(floor(n), high_bit)
    end
    return bit_and(floor(n), 0xFFFFFFFF)
end

local bit_lshift = function(n, bits)
    if(n < 0) then
        -- negative
        n = bit_not(math.abs(n)) + 1
    end
    for _ = 1, bits do
        n = n * 2
    end
    return bit_and(n, 0xFFFFFFFF)
end

return {
    ["bnot"] = bit_not,
    ["bor"] = bit_or,
    ["band"] = bit_and,
    ["bxor"] = bit_xor,
    ["rshift"] = bit_rshift,
    ["lshift"] = bit_lshift,
}

