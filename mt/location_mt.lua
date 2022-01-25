local helper = require "utils.helper"

local mt = {}

function mt:address(options)
    options = helper.init_options(options)
    return self:natural({ min = 5, max = 2000 }) .. " " .. self:street(options)
end

function mt:altitude(options)
    options = helper.init_options(options, { fixed = 5, min = 0, max = 8848 })
    return self:floating({ min = options.min, max = options.max, fixed = options.fixed })
end

function mt:areacode(options)
    options = helper.init_options(options, { parens = true })
    -- Don't want area codes to start with 1, or have a 9 as the second digit
    local areacode = options.example_number and "555" or
            tostring(self:natural({ min = 2, max = 9 })) ..
            tostring(self:natural({ min = 0, max = 8 })) ..
            tostring(self:natural({ min = 0, max = 9 }))
    return options.parens and "(" .. areacode .. ")" or areacode
end

function mt:city()
    return self:capitalize(self:word({ syllables = 3 }))
end

function mt:coordinates(options)
    return self:latitude(options) .. ", " .. self:longitude(options)
end

function mt:country(options)
    options = helper.init_options(options)
    local country = self:pick(self:get("countries"))
    return options.raw and country or (options.full and country.name or country.abbreviation)
end

function mt:depth(options)
    options = helper.init_options(options, { fixed = 5, min = -10994, max = 0 })
    return self:floating({ min = options.min, max = options.max, fixed = options.fixed })
end

function mt:geohash(options)
    options = helper.init_options(options, { length = 7 })
    return self:string({ length = options.length, pool = "0123456789bcdefghjkmnpqrstuvwxyz" })
end

function mt:geojson(options)
    return self:latitude(options) .. ", " .. self:longitude(options) ..
        ", " .. self:altitude(options)
end

function mt:latitude(options)
    local default = { fixed = 5, min = -90, max = 90, format = "dd" }
    local format = options and options.format
    if format then
        format = string.lower(format)
        if format == "ddm" or format == "dms" then
            default = { min = 0, max = 89, fixed = 4 }
        end
    end
    options = helper.init_options(options, default)
    if format == "ddm" or format == "dms" then
        assert(options.min >= 0 and options.min <= 89,
                "Chance: Min specified is out of range. Should be between 0 - 89")
        assert(options.max >= 0 and options.max <= 89,
                "Chance: Max specified is out of range. Should be between 0 - 89")
        assert(options.fixed <= 4, "Chance: Fixed specified should be below or equal to 4")
    end
    if format == "ddm" then
        return self:integer({ min = options.min, max = options.max }) ..
                "°" .. self:floating({ min = 0, max = 59, fixed = options.fixed })
    elseif format == "dms" then
        return self:integer({ min = options.min, max = options.max }) ..
                "°" .. self:integer({ min = 0, max = 59 }) ..
                "’" .. self:floating({ min = 0, max = 59, fixed = options.fixed }) ..
                "”"
    else
        return self:floating({ min = options.min, max = options.max, fixed = options.fixed })
    end
end

function mt:longitude(options)
    local default = { fixed = 5, min = -180, max = 180, format = "dd" }
    local format = options and options.format
    if format then
        format = string.lower(format)
        if format == "ddm" or format == "dms" then
            default = { min = 0, max = 179, fixed = 4 }
        end
    end
    options = helper.init_options(options, default)
    if format == "ddm" or format == "dms" then
        assert(options.min >= 0 and options.min <= 179,
                "Chance: Min specified is out of range. Should be between 0 - 179")
        assert(options.max >= 0 and options.max <= 179,
                "Chance: Max specified is out of range. Should be between 0 - 179")
        assert(options.fixed <= 4, "Chance: Fixed specified should be below or equal to 4")
    end
    if format == "ddm" then
        return self:integer({ min = options.min, max = options.max }) ..
                "°" .. self:floating({ min = 0, max = 59.9999, fixed = options.fixed })
    elseif format == "dms" then
        return self:integer({ min = options.min, max = options.max }) ..
                "°" .. self:integer({ min = 0, max = 59 }) ..
                "’" .. self:floating({ min = 0, max = 59.9999, fixed = options.fixed }) ..
                "”"
    else
        return self:floating({ min = options.min, max = options.max, fixed = options.fixed })
    end
end

function mt:phone(options)
    options = helper.init_options(options, {
        formatted = true,
        country = "us",
        mobile = false,
        example_number = false,
    })
    local uk_num = function(parts)
        local section = {}
        -- fills the section part of the phone number with random numbers.
        for _, v in pairs(parts.sections) do
            section[#section + 1] = self:string({ pool = "0123456789", length = v })
        end
        return parts.area .. table.concat(section, " ")
    end
    local fr_num = function(s)
        local r = {}
        for w in string.gmatch(s, "..") do
            r[#r + 1] = w
        end
        return table.concat(r, " ")
    end
    local fr_process = function(this, opt)
        local num_pick
        if not(opt.mobile) then
            num_pick = this:pick({
                -- Valid zone and département codes.
                '01' .. this:pick({ '30', '34', '39', '40', '41', '42', '43', '44',
                    '45', '46', '47', '48', '49', '53', '55', '56', '58', '60', '64',
                    '69', '70', '72', '73', '74', '75', '76', '77', '78', '79', '80',
                    '81', '82', '83' }) ..
                this:string({ pool = "0123456789", length = 6 }),
                '02' .. this:pick({ '14', '18', '22', '23', '28', '29', '30', '31',
                    '32', '33', '34', '35', '36', '37', '38', '40', '41', '43', '44',
                    '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '56',
                    '57', '61', '62', '69', '72', '76', '77', '78', '85', '90', '96',
                    '97', '98', '99' }) ..
                this:string({ pool = "0123456789", length = 6 }),
                '03' .. this:pick({ '10', '20', '21', '22', '23', '24', '25', '26',
                    '27', '28', '29', '39', '44', '45', '51', '52', '54', '55', '57',
                    '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68',
                    '69', '70', '71', '72', '73', '80', '81', '82', '83', '84', '85',
                    '86', '87', '88', '89', '90' }) ..
                this:string({ pool = "0123456789", length = 6 }),
                '04' .. this:pick({ '11', '13', '15', '20', '22', '26', '27', '30',
                    '32', '34', '37', '42', '43', '44', '50', '56', '57', '63', '66',
                    '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77',
                    '78', '79', '80', '81', '82', '83', '84', '85', '86', '88', '89',
                    '90', '91', '92', '93', '94', '95', '97', '98' }) ..
                this:string({ pool = "0123456789", length = 6 }),
                '05' .. this:pick({ '08', '16', '17', '19', '24', '31', '32', '33',
                    '34', '35', '40', '45', '46', '47', '49', '53', '55', '56', '57',
                    '58', '59', '61', '62', '63', '64', '65', '67', '79', '81', '82',
                    '86', '87', '90', '94' }) ..
                this:string({ pool = "0123456789", length = 6 }),
                '09' .. this:string({ pool = "0123456789", length = 8 }),
            })
            return opt.formatted and fr_num(num_pick) or num_pick
        else
            num_pick = this:pick({ "06", "07" }) ..
                this:string({ pool = "0123456789", length = 8 })
            return opt.formatted and fr_num(num_pick) or num_pick
        end
    end
    local uk_process = function(this, opt)
        local num_pick
        if not(opt.mobile) then
            num_pick = this:pick({
                -- valid area codes of major cities/counties followed by random numbers in required format.
                { area = '01' .. this:character({ pool = '234569' }) .. '1 ',
                    sections = { 3, 4 } },
                { area = '020 ' .. this:character({ pool = '378' }), sections = { 3, 4 } },
                { area = '024 7', sections = { 3, 4 } },
                { area = '028 ' .. this:pick({ '25','28','37','71','82','90','92','95' }),
                    sections = { 2, 4 } },
                { area = '012' .. this:pick({ '04','08','54','76','97','98' }) .. ' ',
                    sections = { 6 } },
                { area = '013' .. this:pick({ '63','64','84','86' }) .. ' ',
                    sections = { 6 } },
                { area = '014' .. this:pick({ '04','20','60','61','80','88' }) .. ' ',
                    sections = { 6 } },
                { area = '015' .. this:pick({ '24','27','62','66' }) .. ' ',
                    sections = { 6 } },
                { area = '016' .. this:pick({ '06','29','35','47','59','95' }) .. ' ',
                    sections = { 6 } },
                { area = '017' .. this:pick({ '26','44','50','68' }) .. ' ', sections = { 6 } },
                { area = '018' .. this:pick({ '27','37','84','97' }) .. ' ', sections = { 6 } },
                { area = '019' .. this:pick({ '00','05','35','46','49','63','95' }) .. ' ',
                    sections = { 6 } },
            })
            return opt.formatted and uk_num(num_pick) or
                table.concat(helper.split(uk_num(num_pick), " "))
        else
            num_pick = this:pick({
                { area = "07" .. this:pick({ '4','5','7','8','9' }), sections = { 2, 6 } },
                { area = "07624 ", sections = { 6 } },
            })
            return opt.formatted and uk_num(num_pick) or
                table.concat(helper.split(uk_num(num_pick), " "))
        end
    end
    local za_process = function(this, opt)
        local num_pick
        if not(opt.mobile) then
            num_pick = this:pick({
                '01' .. this:pick({ '0', '1', '2', '3', '4', '5', '6', '7', '8' }) ..
                    this:string({ pool = "0123456789", length = 7 }),
                '02' .. this:pick({ '1', '2', '3', '4', '7', '8' }) ..
                    this:string({ pool = "0123456789", length = 7 }),
                '03' .. this:pick({ '1', '2', '3', '5', '6', '9' }) ..
                    this:string({ pool = "0123456789", length = 7 }),
                '04' .. this:pick({ '1', '2', '3', '4', '5','6','7', '8','9' }) ..
                    this:string({ pool = "0123456789", length = 7 }),
                '05' .. this:pick({ '1', '3', '4', '6', '7', '8' }) ..
                    this:string({ pool = "0123456789", length = 7 }),
            })
            return opt.formatted or num_pick
        else
            num_pick = this:pick({
                '060' .. this:pick({ '3','4','5','6','7','8','9' }) ..
                    this:string({ pool = "0123456789", length = 6 }),
                '061' .. this:pick({ '0','1','2','3','4','5','8' }) ..
                    this:string({ pool = "0123456789", length = 6 }),
                '06' .. this:string({ pool = "0123456789", length = 7 }),
                '071' .. this:pick({ '0','1','2','3','4','5','6','7','8','9' }) ..
                    this:string({ pool = "0123456789", length = 6 }),
                '07' .. this:pick({ '2','3','4','6','7','8','9' }) ..
                    this:string({ pool = "0123456789", length = 7 }),
                '08' .. this:pick({ '0','1','2','3','4','5' }) ..
                    this:string({ pool = "0123456789", length = 7 }),
            })
            return opt.formatted or num_pick
        end
    end
    local us_process = function(this, opt)
        local area_code = tostring(this:areacode(opt))
        local exchange = tostring(this:natural({ min = 2, max = 9 })) ..
                    tostring(this:natural({ min = 0, max = 9 })) ..
                    tostring(this:natural({ min = 0, max = 9 }))
        local subscriber = tostring(this:natural({ min = 1000, max = 9999 })) -- this could be random [0-9]{4}
        return opt.formatted and area_code .. ' ' .. exchange .. '-' .. subscriber or
                area_code .. exchange .. subscriber
    end
    local br_process = function(this, opt)
        local area_code = this:pick({"11", "12", "13", "14", "15", "16", "17",
            "18", "19", "21", "22", "24", "27", "28", "31", "32", "33", "34",
            "35", "37", "38", "41", "42", "43", "44", "45", "46", "47", "48",
            "49", "51", "53", "54", "55", "61", "62", "63", "64", "65", "66",
            "67", "68", "69", "71", "73", "74", "75", "77", "79", "81", "82",
            "83", "84", "85", "86", "87", "88", "89", "91", "92", "93", "94",
            "95", "96", "97", "98", "99" })
        local prefix
        if opt.mobile then
            -- Brasilian official reference (mobile):
            -- http://www.anatel.gov.br/setorregulado/plano-de-numeracao-brasileiro?id=330
            prefix = '9' .. this:string({ pool = "0123456789", length = 4 })
        else
            -- Brasilian official reference:
            -- http://www.anatel.gov.br/setorregulado/plano-de-numeracao-brasileiro?id=331
            prefix = tostring(this:natural({ min = 2000, max = 5999 }))
        end
        local mcdu = this:string({ pool = "0123456789", length = 4 })
        return opt.formatted and "(" .. area_code .. ") " .. prefix .. '-' .. mcdu or
                area_code .. prefix .. mcdu
    end

    if not(options.formatted) then
        options.parens = false
    end
    if options.country == "fr" then
        return fr_process(self, options)
    elseif options.country == "uk" then
        return uk_process(self, options)
    elseif options.country == "za" then
        return za_process(self, options)
    elseif options.country == "us" then
        return us_process(self, options)
    elseif options.country == "br" then
        return br_process(self, options)
    end
end

function mt:postal()
    -- Postal District
    local pd = self:character({ pool = "XVTSRPNKLMHJGECBA" })
    -- Forward Sortation Area (FSA)
    local fsa = pd .. self:natural({ max = 9 }) .. self:character({ alpha = true, casing = "upper" })
    -- Local Delivery Unut (LDU)
    local ldu = self:natural({ max = 9 }) ..
            self:character({ alpha = true, casing = "upper" }) ..
            self:natural({ max = 9 })
    return fsa .. " " .. ldu
end

function mt:postcode()
    -- Area
    local area = self:pick(self:get("postcodeAreas")).code
    -- District
    local district = self:natural({ max = 9 })
    -- Sub-District
    local sub_district = self:bool() and self:character({ alpha = true, casing = "upper" }) or ""
    -- Outward Code
    local outward = area .. district .. sub_district
    -- Sector
    local sector = self:natural({ max = 9 })
    -- Unit
    local unit = self:character({ alpha = true, casing = "upper" }) ..
            self:character({ alpha = true, casing = "upper" })
    -- Inward Code
    local inward = sector .. unit
    return outward .. " " .. inward
end

function mt:county(options)
    options = helper.init_options(options, { country = "uk" })
    return self:pick(self:get("counties")[string.lower(options.country)]).name
end

function mt:province(options)
    options = helper.init_options(options, { country = "ca" })
    if options and options.full then
        return self:pick(self:get("provinces")[string.lower(options.country)]).name
    else
        return self:pick(self:get("provinces")[string.lower(options.country)]).abbreviation
    end
end

function mt:state(options)
    options = helper.init_options(options, { country = "us", us_states_and_dc = true })
    local states = {}
    local lc = string.lower(options.country)
    if lc == "us" then
        local us_states_and_dc = self:get("us_states_and_dc")
        local territories = self:get("territories")
        local armed_forces = self:get("armed_forces")
        if options.us_states_and_dc then
            table.move(us_states_and_dc, 1, #us_states_and_dc, #states + 1, states)
        end
        if options.territories then
            table.move(territories, 1, #territories, #states + 1, states)
        end
        if options.armed_forces then
            table.move(armed_forces, 1, #armed_forces, #states + 1, states)
        end
    elseif lc == "it" or lc == "mx" then
        states = self:get("country_regions")[string.lower(options.country)]
    elseif lc == "uk" then
        states = self:get("counties")[string.lower(options.country)]
    end
    if options and options.full then
        return self:pick(states).name
    else
        return self:pick(states).abbreviation
    end
end

function mt:street(options)
    options = helper.init_options(options, { country = "us", syllables = 2 })
    local country = string.lower(options.country)
    local street
    if country == "us" then
        street = self:word({ syllables = options.syllables })
        street = self:capitalize(street)
        street = street .. " "
        street = street .. (options.short_suffix and
                self:street_suffix(options).abbreviation or
                self:street_suffix(options).name)
    elseif country == "it" then
        street = self:word({ syllables = options.syllables })
        street = self:capitalize(street)
        street = (options.short_suffix and
                self:street_suffix(options).abbreviation or
                self:street_suffix(options).name) .. " " .. street
    end
    return street
end

function mt:street_suffix(options)
    options = helper.init_options(options, { country = "us" })
    return self:pick(self:get("street_suffixes")[string.lower(options.country)])
end

-- Note: only returning US zip codes, internationalization will be a whole
-- other beast to tackle at some point.
function mt:zip(options)
    local zip = self:n(self.natural, self, 5, { max = 9 })
    if options and options.plusfour then
        zip[#zip + 1] = '-'
        local arr = self:n(self.natural, self, 4, { max = 9 })
        table.move(arr, 1, #arr, #zip + 1, zip)
    end
    return table.concat(zip)
end

return mt
