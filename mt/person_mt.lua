local helper = require "utils.helper"

local mt = {}

function mt:age(options)
    options = helper.init_options(options)
    local age_range
    if options.type == "child" then
        age_range = { min = 0, max = 12 }
    elseif options.type == "teen" then
        age_range = { min = 13, max = 19 }
    elseif options.type == "adult" then
        age_range = { min = 18, max = 65 }
    elseif options.type == "senior" then
        age_range = { min = 65, max = 100 }
    elseif options.type == "all" then
        age_range = { min = 0, max = 100 }
    else
        age_range = { min = 18, max = 65 }
    end
    return self:natural(age_range)
end

function mt:birthday(options)
    local age = self:age(options)
    local cur_year = os.date("*t").year
    if options and options.type then
        local min = os.time({
            year = cur_year - age - 1,
            month = 1,
            day = 1,
            hour = 0,
            min = 0,
            sec = 0,
        })
        local max = os.time({
            year = cur_year - age,
            month = 12,
            day = 31,
            hour = 23,
            min = 59,
            sec = 60,
        })
        options = helper.init_options(options, { min = min, max = max })
    else
        options = helper.init_options(options, { year = cur_year - age })
    end
    return self:date(options)
end

-- CPF; ID to identify taxpayers in Brazil
function mt:cpf(options)
    options = helper.init_options(options, { formatted = true })
    local n = self:n(self.natural, self, 9, { max = 9 })
    local d1 = n[9] * 2 + n[8] * 3 + n[7] * 4 + n[6] * 5 + n[5] * 6 + n[4] * 7 +
            n[3] * 8 + n[2] * 9 + n[1] * 10
    d1 = 11 - (d1 % 11)
    if d1 >= 10 then
        d1 = 0
    end
    local d2 = d1 * 2 + n[9] * 3 + n[8] * 4 + n[7] * 5 + n[6] * 6 + n[5] * 7 +
            n[4] * 8 + n[3] * 9 + n[2] * 10 + n[1] * 11
    d2 = 11 - (d2 % 11)
    if d2 >= 10 then
        d2 = 0
    end
    local cpf = table.concat(n, nil, 1, 3) .. "." .. table.concat(n, nil, 4, 6) ..
            "." .. table.concat(n, nil, 7, 9) .. "-" .. d1 .. d2
    return options.formatted and cpf or (string.gsub(cpf, "[^%d]", ""))
end

function mt:first(options)
    options = helper.init_options(options, {
        gender = self:gender(), nationality = "en",
    })
    local l_gender = string.lower(options.gender)
    local l_nat = string.lower(options.nationality)
    return self:pick(self:get("firstNames")[l_gender][l_nat])
end

function mt:profession(options)
    options = helper.init_options(options)
    if options.rank then
        return self:pick({ 'Apprentice ', 'Junior ', 'Senior ', 'Lead ' }) ..
            self:pick(self:get("profession"))
    else
        return self:pick(self:get("profession"))
    end
end

function mt:company()
    return self:pick(self:get("company"))
end

function mt:gender(options)
    options = helper.init_options(options, { extra_genders = {} })
    return self:pick(table.move(options.extra_genders, 1,
            #options.extra_genders, 3, { "Male", "Female" }))
end

function mt:last(options)
    options = helper.init_options(options, { nationality = "*" })
    if options.nationality == "*" then
        local all_last_names = {}
        local last_names = self:get("lastNames")
        for _, v in pairs(last_names) do
            table.move(v, 1, #v, #all_last_names + 1, all_last_names)
        end
        return self:pick(all_last_names)
    else
        return self:pick(self:get("lastNames")[string.lower(options.nationality)])
    end
end

function mt:israelId()
    local x = self:string({ pool = "0123456789", length = 8 })
    local y = 0
    for i = 1, string.len(x) do
        local this_digit = tonumber(string.sub(x, i, i)) * (i % 2 == 0 and 1 or 2)
        this_digit = tostring(self:pad(this_digit, 2))
        this_digit = tonumber(string.sub(this_digit, 1, 1)) + tonumber(string.sub(this_digit, 2, 2))
        y = y + this_digit
    end
    x = x .. string.sub(tostring(10 - tonumber(string.sub(tostring(y), -1))), -1)
    return x
end

function mt:mrz(options)
    local check_digit = function(input)
        local alpha = {}
        for c in string.gmatch("<ABCDEFGHIJKLMNOPQRSTUVWXYZ", ".") do
            alpha[#alpha + 1] = c
        end
        local multipliers = { 7, 3, 1 }
        local running_total = 0
        if type(input) ~= "string" then
            input = tostring(input)
        end
        local idx = 0
        for c in string.gmatch(input, ".") do
            local b
            for i, v in ipairs(alpha) do
                if v == c then
                    b = i - 1
                    break
                end
            end
            if b then
                c = b == 0 and 0 or b + 9
            else
                c = tonumber(c, 10)
            end
            c = c * multipliers[(idx % #multipliers) + 1]
            running_total = running_total + c
            idx = idx + 1
        end
        return running_total % 10
    end
    local generate = function(opts)
        local pad = function(length)
            local sep = ""
            for _ = 1, length do
                sep = sep .. "<"
            end
            return sep
        end
        local number = {
            "P<", opts.issuer, string.upper(opts.last), "<<", string.upper(opts.first),
            pad(39 - (string.len(opts.last) + string.len(opts.first) + 2)),
            opts.passport_number, check_digit(opts.passport_number), opts.nationality,
            opts.dob, check_digit(opts.dob), opts.gender, opts.expiry,
            check_digit(opts.expiry), pad(14), check_digit(pad(14)),
        }
        local number_str = ""
        for _, v in ipairs(number) do
            number_str = number_str .. v
        end
        return number_str .. check_digit(string.sub(number_str, 45, 54) ..
                string.sub(number_str, 58, 64) .. string.sub(number_str, 66, 72))
    end
    local calc_dob = function()
        local date = self:birthday({ type = "adult" })
        return string.sub(tostring(date.year), 3) .. self:pad(date.month, 2) ..
            self:pad(date.day, 2)
    end
    local calc_expiry = function()
        local date = os.date("*t")
        return string.sub(tostring(date.year + 5), 3) .. self:pad(date.month, 2) ..
            self:pad(date.day, 2)
    end
    options = helper.init_options(options, {
        first = self:first(),
        last = self:last(),
        passport_number = self:integer({ min = 100000000, max = 999999999 }),
        dob = calc_dob(),
        expiry = calc_expiry(),
        gender = self:gender() == "Female" and "F" or "M",
        issuer = "GBR",
        nationality = "GBR",
    })
    return generate(options)
end

function mt:name(options)
    options = helper.init_options(options)
    local first = self:first(options)
    local last = self:last(options)
    local name
    if options.middle then
        name = first .. " " .. self:first(options) .. " " .. last
    elseif options.middle_initial then
        name = first .. " " .. self:character({ alpha = true, casing = "upper" }) .. ". " .. last
    else
        name = first .. " " .. last
    end
    if options.prefix then
        name = self:prefix(options) .. " " .. name
    end
    if options.suffix then
        name = name .. " " .. self:suffix(options)
    end
    return name
end

function mt:prefix(options)
    options = helper.init_options(options, { gender = "all" })
    local gender = string.lower(options.gender)
    local prefixes = {
        { name = "Doctor", abbreviation = "Dr." },
    }
    if gender == "male" or gender == "all" then
        table.insert(prefixes, { name = "Mister", abbreviation = "Mr." })
    end
    if gender == "female" or gender == "all" then
        table.insert(prefixes, { name = "Miss", abbreviation = "Miss" })
        table.insert(prefixes, { name = "Misses", abbreviation = "Mrs." })
    end
    return options.full and self:pick(prefixes).name or self:pick(prefixes).abbreviation
end

-- Hungarian ID number
function mt:HIDN()
    -- Hungarian ID nuber structure: XXXXXXYY (X=number,Y=Capital Latin letter)
    local idn_pool = "0123456789"
    local idn_chrs = "ABCDEFGHIJKLMNOPQRSTUVWXYXZ"
    local idn = ""
    idn = idn .. self:string({ pool = idn_pool, length = 6 })
    idn = idn .. self:string({ pool = idn_chrs, length = 2 })
    return idn
end

function mt:ssn(options)
    options = helper.init_options(options, { ssn_four = false, dashes = true })
    local ssn_pool = "1234567890"
    local ssn
    local dash = options.dashes and '-' or ''
    if not(options.ssn_four) then
        ssn = self:string({ pool = ssn_pool, length = 3 }) .. dash ..
            self:string({ pool = ssn_pool, length = 2 }) .. dash ..
            self:string({ pool = ssn_pool, length = 4 })
    else
        ssn = self:string({ pool = ssn_pool, length = 4 })
    end
    return ssn
end

-- Aadhar is similar to ssn, used in India to uniquely identify a person
function mt:aadhar(options)
    options = helper.init_options(options, {
        only_last_four = false,
        separated_by_whitespace = true,
    })
    local aadhar_pool = "1234567890"
    local whitespace = options.separated_by_whitespace and " " or ""
    local aadhar_str
    if not(options.only_last_four) then
        aadhar_str = self:string({ pool = aadhar_pool, length = 4 }) .. whitespace ..
            self:string({ pool = aadhar_pool, length = 4 }) .. whitespace ..
            self:string({ pool = aadhar_pool, length = 4 })
    else
        aadhar_str = self:string({ pool = aadhar_pool, length = 4 })
    end
    return aadhar_str
end

function mt:suffix(options)
    options = helper.init_options(options)
    local suffixes = {
        { name = 'Doctor of Osteopathic Medicine', abbreviation = 'D.O.' },
        { name = 'Doctor of Philosophy', abbreviation =  'Ph.D.' },
        { name = 'Esquire', abbreviation = 'Esq.' },
        { name = 'Junior', abbreviation = 'Jr.' },
        { name = 'Juris Doctor', abbreviation = 'J.D.' },
        { name = 'Master of Arts', abbreviation = 'M.A.' },
        { name = 'Master of Business Administration', abbreviation = 'M.B.A.' },
        { name = 'Master of Science', abbreviation = 'M.S.' },
        { name = 'Medical Doctor', abbreviation = 'M.D.' },
        { name = 'Senior', abbreviation = 'Sr.' },
        { name = 'The Third', abbreviation = 'III' },
        { name = 'The Fourth', abbreviation = 'IV' },
        { name = 'Bachelor of Engineering', abbreviation = 'B.E' },
        { name = 'Bachelor of Technology', abbreviation = 'B.TECH' },
    }
    return options.full and self:pick(suffixes).name or self:pick(suffixes).abbreviation
end

-- Generate random nationality based on json list
function mt:nationality()
    return self:pick(self:get("nationalities")).name
end

return mt
