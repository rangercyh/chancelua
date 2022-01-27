local mt = {}

function mt:it_vat()
    local it_vat = self:natural({ min = 1, max = 1800000 })
    it_vat = self:pad(it_vat, 7) .. self:pad(self:pick(self:get("provinces")["it"]).code, 3)
    return it_vat .. self:luhn_calculate(it_vat)
end

local name_generator = function(name, is_last)
    local arr = {}
    if string.len(name) < 3 then
        for w in string.gmatch(name, ".") do
            arr[#arr + 1] = w
        end
        for i = #arr, 3 do
            arr[i] = "X"
        end
        return table.concat(arr)
    else
        for w in string.gmatch(name, ".") do
            local c = string.upper(w)
            if string.find("BCDFGHJKLMNPRSTVWZ", c) then
                arr[#arr + 1] = c
            end
        end
        local temp = table.concat(arr)
        if string.len(temp) > 3 then
            if is_last then
                temp = string.sub(temp, 1, 3)
            else
                temp = string.sub(temp, 1, 1) .. string.sub(temp, 3, 4)
            end
        end
        local str = ""
        if string.len(temp) < 3 then
            str = temp
            local len = 3 - string.len(temp)
            arr = {}
            for w in string.gmatch(name, ".") do
                local c = string.upper(w)
                if string.find("AEIOU", c) then
                    arr[#arr + 1] = c
                end
            end
            temp = string.sub(table.concat(arr), 1, len)
        end
        return str .. temp
    end
end

local date_generator = function(self, birthday, gender)
    local lettermonths = { 'A', 'B', 'C', 'D', 'E', 'H', 'L', 'M', 'P', 'R', 'S', 'T' }
    local year, month, day = birthday.year, birthday.month, birthday.day
    return string.sub(tostring(year), 3) .. lettermonths[month] ..
        self:pad(day + (string.lower(gender) == "female" and 40 or 0), 2)
end

local checkdigit_generator = function(cf)
    local range1 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local range2 = "ABCDEFGHIJABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local evens = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local odds = "BAKPLCQDREVOSFTGUHMINJWZYX"
    local digit = 0
    for i = 1, 15 do
        local r1 = string.find(range1, string.sub(cf, i, i))
        local r2 = string.sub(range2, r1, r1)
        if i % 2 == 0 then
            digit = digit + string.find(evens, r2) - 1
        else
            digit = digit + string.find(odds, r2) - 1
        end
    end
    local pos = digit % 26 + 1
    return string.sub(evens, pos, pos)
end
--[[
this generator is written following the official algorithm
all data can be passed explicitely or randomized by calling chance.cf() without options
the code does not check that the input data is valid (it goes beyond the scope of the generator)

@param  [Object] options = { first: first name,
                             last: last name,
                             gender: female|male,
                             birthday: JavaScript date object,
                             city: string(4), 1 letter + 3 numbers
                            }
@return [string] codice fiscale
]]
function mt:cf(options)
    options = options or {}
    local gender = options.gender or self:gender()
    local first = options.first or self:first({ gender = gender, nationality = "it" })
    local last = options.last or self:last({ nationality = "it" })
    local birthday = options.birthday or self:birthday()
    local city = options.city or (self:pickone({ 'A', 'B', 'C', 'D', 'E', 'F',
        'G', 'H', 'I', 'L', 'M', 'Z' }) .. self:pad(self:natural({ max = 999 }), 3))
    local cf = {
        name_generator(last, true),
        name_generator(first),
        date_generator(self, birthday, gender),
    }
    for w in string.gmatch(string.upper(city), ".") do
        cf[#cf + 1] = w
    end
    cf = table.concat(cf)
    cf = cf .. checkdigit_generator(string.upper(cf))
    return string.upper(cf)
end

function mt:pl_pesel()
    local number = self:natural({ min = 1, max = 9999999999 })
    local str = self:pad(number, 10)
    local arr = {}
    for w in string.gmatch(str, ".") do
        arr[#arr + 1] = tonumber(w)
    end
    local control_number = (1 * arr[1] + 3 * arr[2] + 7 * arr[3] + 9 * arr[4] +
            1 * arr[5] + 3 * arr[6] + 7 * arr[7] + 9 * arr[8] + 1 * arr[9] +
            3 * arr[10]) % 10
    if control_number ~= 0 then
        control_number = 10 - control_number
    end
    return table.concat(arr) .. control_number
end

function mt:pl_nip()
    local number = self:natural({ min = 1, max = 999999999 })
    local str = self:pad(number, 9)
    local arr = {}
    for w in string.gmatch(str, ".") do
        arr[#arr + 1] = tonumber(w)
    end
    local control_number = (6 * arr[1] + 5 * arr[2] + 7 * arr[3] + 2 * arr[4] +
            3 * arr[5] + 4 * arr[6] + 5 * arr[7] + 6 * arr[8] + 7 * arr[9]) % 11
    if control_number == 10 then
        return self:pl_nip()
    end
    return table.concat(arr) .. control_number
end

function mt:pl_regon()
    local number = self:natural({ min = 1, max = 99999999 })
    local str = self:pad(number, 8)
    local arr = {}
    for w in string.gmatch(str, ".") do
        arr[#arr + 1] = tonumber(w)
    end
    local control_number = (8 * arr[1] + 9 * arr[2] + 2 * arr[3] + 3 * arr[4] +
            4 * arr[5] + 5 * arr[6] + 6 * arr[7] + 7 * arr[8]) % 11
    if control_number == 10 then
        control_number = 0
    end
    return table.concat(arr) .. control_number
end

return mt
