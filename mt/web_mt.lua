local helper = require "utils.helper"

local mt = {}

local gray = function(value, delimiter)
    return table.concat({ value, value, value }, delimiter or "")
end
local rgb = function(self, has_alpha, is_grayscale, min_alpha, max_alpha,
        min_rgb, max_rgb, min_green, max_green, min_blue, max_blue)
    local rgb_val = has_alpha and "rgba" or "rgb"
    local alpha_ch = has_alpha and
        ("," .. self:floating({ min = min_alpha, max = max_alpha })) or ""
    local color_val = is_grayscale and
        (gray(self:natural({ min = min_rgb, max = max_rgb }), ",")) or
        (
            self:natural({ min = min_green, max = max_green }) .. "," ..
            self:natural({ min = min_blue, max = max_blue }) .. "," ..
            self:natural({ max = 255 })
        )
    return rgb_val .. "(" .. color_val .. alpha_ch .. ")"
end
local create_hexstring = function(self, min_red, max_red, min_green, max_green, min_blue, max_blue, n)
    return self:pad(self:hex({
            min = min_red,
            max = max_red,
        }), n) ..
        self:pad(self:hex({
            min = min_green,
            max = max_green,
        }), n) ..
        self:pad(self:hex({
            min = min_blue,
            max = max_blue,
        }), n)
end
local get_gray_hexstring = function(self, options, min_rgb, max_rgb)
    local hexstring = gray(self:pad(self:hex({ min = min_rgb, max = max_rgb }), 2))
    if options.format == "shorthex" then
        hexstring = gray(self:hex({ min = 0, max = 15 }))
    end
    return hexstring
end
local hex = function(self, options, with_hash, is_grayscale, min_rgb, max_rgb,
        min_red, max_red, min_green, max_green, min_blue, max_blue)
    local symbol = with_hash and "#" or ""
    local hexstring
    if is_grayscale then
        hexstring = get_gray_hexstring(self, options, min_rgb, max_rgb)
    else
        if options.format == "shorthex" then
            hexstring = create_hexstring(self, math.floor(min_red / 16),
                math.floor(max_red / 16), math.floor(min_green / 16),
                math.floor(max_green / 16), math.floor(min_blue / 16),
                math.floor(max_blue / 16), 1)
        elseif min_red or max_red or min_green or max_green or min_blue or
               max_blue then
            hexstring = create_hexstring(self, min_red, max_red, min_green,
                max_green, min_blue, max_blue, 2)
        else
            hexstring = create_hexstring(self, min_rgb, min_rgb, min_rgb,
                min_rgb, min_rgb, min_rgb, 2)
        end
    end
    return symbol .. (hexstring or "")
end
local color_value = function(self, options, is_grayscale, min_rgb, max_rgb,
        min_red, max_red, min_green, max_green, min_blue, max_blue, min_alpha,
        max_alpha)
    if options.format == "hex" then
        return hex(self, options, true, is_grayscale, min_rgb,
            max_rgb, min_red, max_red, min_green, max_green, min_blue,
            max_blue)
    elseif options.format == "shorthex" then
        return hex(self, options, true, is_grayscale, min_rgb,
            max_rgb, min_red, max_red, min_green, max_green, min_blue,
            max_blue)
    elseif options.format == "rgb" then
        return rgb(self, false, is_grayscale, min_alpha, max_alpha,
            min_rgb, max_rgb, min_green, max_green, min_blue, max_blue)
    elseif options.format == "rgba" then
        return rgb(self, true, is_grayscale, min_alpha, max_alpha,
            min_rgb, max_rgb, min_green, max_green, min_blue, max_blue)
    elseif options.format == "0x" then
        return "0x" .. hex(self, options, false, is_grayscale, min_rgb,
            max_rgb, min_red, max_red, min_green, max_green, min_blue,
            max_blue)
    elseif options.format == "name" then
        return self:pick(self:get("colorNames"))
    else
        assert(false, 'Invalid format provided. Please provide one of "hex", \
            "shorthex", "rgb", "rgba", "0x" or "name".')
    end
end
--[[
#Description:
===============================================
Generate random color value base on color type:
-> hex
-> rgb
-> rgba
-> 0x
-> named color
#Examples:
===============================================
* Geerate random hex color
chance.color() => '#79c157' / 'rgb(110,52,164)' / '0x67ae0b' / '#e2e2e2' / '#29CFA7'
* Generate Hex based color value
chance.color({format: 'hex'})    => '#d67118'
* Generate simple rgb value
chance.color({format: 'rgb'})    => 'rgb(110,52,164)'
* Generate Ox based color value
chance.color({format: '0x'})     => '0x67ae0b'
* Generate graiscale based value
chance.color({grayscale: true})  => '#e2e2e2'
* Return valide color name
chance.color({format: 'name'})   => 'red'
* Make color uppercase
chance.color({casing: 'upper'})  => '#29CFA7'
* Min Max values for RGBA
var light_red = chance.color({format: 'hex', min_red: 200, max_red: 255, max_green: 0,
    max_blue: 0, min_alpha: .2, max_alpha: .3});
@param  [object] options
@return [string] color value
]]
function mt:color(options)
    local init_rgb = function(min_rgb, max_rgb, is_grayscale, min_red, max_red,
            min_green, max_green, min_blue, max_blue)
        if is_grayscale and min_rgb == 0 and max_rgb == 255 and min_red and max_red then
            min_rgb = (min_red + min_green + min_blue) / 3
            max_rgb = (max_red + max_green + max_blue) / 3
        end
        return min_rgb, max_rgb
    end
    options = helper.init_options(options, {
        format = self:pick({
            'hex', 'shorthex', 'rgb', 'rgba', '0x', 'name'
        }),
        grayscale = false,
        casing = "lower",
        min = 0,
        max = 255,
        min_red = nil,
        max_red = nil,
        min_green = nil,
        max_green = nil,
        min_blue = nil,
        max_blue = nil,
        min_alpha = 0,
        max_alpha = 1,
    })
    local is_grayscale = options.grayscale
    local min_rgb = options.min
    local max_rgb = options.max
    local min_red = options.min_red or min_rgb
    local max_red = options.max_red or max_rgb
    local min_green = options.min_green or min_rgb
    local max_green = options.max_green or max_rgb
    local min_blue = options.min_blue or min_rgb
    local max_blue = options.max_blue or max_rgb
    local min_alpha = options.min_alpha or 0
    local max_alpha = options.max_alpha or 1
    min_rgb, max_rgb = init_rgb(min_rgb, max_rgb, is_grayscale, min_red, max_red,
            min_green, max_green, min_blue, max_blue)
    local color_val = color_value(self, options, is_grayscale, min_rgb, max_rgb,
        min_red, max_red, min_green, max_green, min_blue, max_blue, min_alpha, max_alpha)
    return options.casing == "upper" and string.upper(color_val) or color_val
end

function mt:domain(options)
    options = helper.init_options(options)
    return self:word() .. "." .. (options.tld or self:tld())
end

function mt:email(options)
    options = helper.init_options(options)
    return self:word({ length = options.length }) .. "@" .. (options.domain or self:domain())
end

--[[
#Description:
===============================================
Generate a random Facebook id, aka fbid.
NOTE: At the moment (Sep 2017), Facebook ids are
"numeric strings" of length 16.
However, Facebook Graph API documentation states that
"it is extremely likely to change over time".
@see https://developers.facebook.com/docs/graph-api/overview/
#Examples:
===============================================
chance.fbid() => '1000035231661304'
@return [string] facebook id
]]
function mt:fbid()
    return "10000" .. self:string({ pool = "1234567890", length = 11 })
end

function mt:google_analytics()
    local account = self:pad(self:natural({ max = 999999 }), 6)
    local property = self:pad(self:natural({ max = 99 }), 2)
    return "UA-" .. account .. "-" .. property
end

function mt:hashtag()
    return "#" ..  self:word()
end

function mt:ip()
    -- Todo: This could return some reserved IPs. See http://vq.io/137dgYy
    -- this should probably be updated to account for that rare as it may be
    return self:natural({ min = 1, max = 254 }) .. "." ..
        self:natural({ max = 255 }) .. "." ..
        self:natural({ max = 255 }) .. "." ..
        self:natural({ min = 1, max = 254 })
end

function mt:ipv6()
    local ip_addr = self:n(self.hash, self, 8, { length = 4 })
    return table.concat(ip_addr, ":")
end

function mt:klout()
    return self:natural({ min = 1, max = 99 })
end

function mt:mac(options)
    -- Todo: This could also be extended to EUI-64 based MACs
    -- (https://www.iana.org/assignments/ethernet-numbers/ethernet-numbers.xhtml#ethernet-numbers-4)
    -- Todo: This can return some reserved MACs (similar to IP function)
    -- this should probably be updated to account for that rare as it may be
    options = helper.init_options(options, { delimiter = ":" })
    local mac_addr = ""
    for _ = 1, 5 do
        mac_addr = mac_addr ..
            self:pad(string.format("%x", self:natural({ max = 255 })), 2) ..
            options.delimiter
    end
    return mac_addr .. self:pad(string.format("%x", self:natural({ max = 255 })), 2)
end

function mt:semver(options)
    options = helper.init_options(options, { include_prerelease = true })
    local range = self:pickone({ "^", "~", "<", ">", "<=", ">=", "=" })
    if options.range then
        range = options.range
    end
    local prerelease = ""
    if options.include_prerelease then
        prerelease = self:weighted({ "", "-dev", "-beta", "-alpha" }, { 50, 10, 5, 1 })
    end
    return range .. table.concat(self:rpg('3d10'), ".") .. prerelease
end

function mt:tld()
    local tlds = { 'com', 'org', 'edu', 'gov', 'co.uk', 'net', 'io', 'ac', 'ad',
        'ae', 'af', 'ag', 'ai', 'al', 'am', 'ao', 'aq', 'ar', 'as', 'at', 'au',
        'aw', 'ax', 'az', 'ba', 'bb', 'bd', 'be', 'bf', 'bg', 'bh', 'bi', 'bj',
        'bm', 'bn', 'bo', 'br', 'bs', 'bt', 'bv', 'bw', 'by', 'bz', 'ca', 'cc',
        'cd', 'cf', 'cg', 'ch', 'ci', 'ck', 'cl', 'cm', 'cn', 'co', 'cr', 'cu',
        'cv', 'cw', 'cx', 'cy', 'cz', 'de', 'dj', 'dk', 'dm', 'do', 'dz', 'ec',
        'ee', 'eg', 'eh', 'er', 'es', 'et', 'eu', 'fi', 'fj', 'fk', 'fm', 'fo',
        'fr', 'ga', 'gb', 'gd', 'ge', 'gf', 'gg', 'gh', 'gi', 'gl', 'gm', 'gn',
        'gp', 'gq', 'gr', 'gs', 'gt', 'gu', 'gw', 'gy', 'hk', 'hm', 'hn', 'hr',
        'ht', 'hu', 'id', 'ie', 'il', 'im', 'in', 'io', 'iq', 'ir', 'is', 'it',
        'je', 'jm', 'jo', 'jp', 'ke', 'kg', 'kh', 'ki', 'km', 'kn', 'kp', 'kr',
        'kw', 'ky', 'kz', 'la', 'lb', 'lc', 'li', 'lk', 'lr', 'ls', 'lt', 'lu',
        'lv', 'ly', 'ma', 'mc', 'md', 'me', 'mg', 'mh', 'mk', 'ml', 'mm', 'mn',
        'mo', 'mp', 'mq', 'mr', 'ms', 'mt', 'mu', 'mv', 'mw', 'mx', 'my', 'mz',
        'na', 'nc', 'ne', 'nf', 'ng', 'ni', 'nl', 'no', 'np', 'nr', 'nu', 'nz',
        'om', 'pa', 'pe', 'pf', 'pg', 'ph', 'pk', 'pl', 'pm', 'pn', 'pr', 'ps',
        'pt', 'pw', 'py', 'qa', 're', 'ro', 'rs', 'ru', 'rw', 'sa', 'sb', 'sc',
        'sd', 'se', 'sg', 'sh', 'si', 'sj', 'sk', 'sl', 'sm', 'sn', 'so', 'sr',
        'ss', 'st', 'su', 'sv', 'sx', 'sy', 'sz', 'tc', 'td', 'tf', 'tg', 'th',
        'tj', 'tk', 'tl', 'tm', 'tn', 'to', 'tp', 'tr', 'tt', 'tv', 'tw', 'tz',
        'ua', 'ug', 'uk', 'us', 'uy', 'uz', 'va', 'vc', 've', 'vg', 'vi', 'vn',
        'vu', 'wf', 'ws', 'ye', 'yt', 'za', 'zm', 'zw' }
    return self:pick(tlds)
end

function mt:twitter()
    return "@" .. self:word()
end

function mt:url(options)
    options = helper.init_options(options, {
        protocol = "http",
        domain = self:domain(options),
        domain_prefix = "",
        path = self:word(),
        extensions = {},
    })

    local extension = #options.extensions > 0 and
            "." .. self:pick(options.extensions) or ""
    local domain = options.domain_prefix and
            options.domain_prefix .. "." .. options.domain or options.domain
    return options.protocol .. "://" .. domain .. "/" .. options.path .. extension
end

function mt:port()
    return self:integer({ min = 0, max = 65535 })
end

function mt:locale(options)
    options = helper.init_options(options)
    if options.region then
        return self:pick(self:get("locale_regions"))
    else
        return self:pick(self:get("locale_languages"))
    end
end

function mt:lorem_picsum(options)
    options = helper.init_options(options, {
        width = 500,
        height = 500,
        greyscale = false,
        blurred = false,
    })
    local greyscale = options.greyscale and "g/" or ""
    local query = options.blurred and "/?blur" or "/?random"

    return "https://picsum.photos/" .. greyscale .. options.width .. "/" ..
            options.height .. query
end

return mt
