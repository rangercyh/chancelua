local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()
tip = 'color() returns what looks like a hex color'
Helper.times_f(function()
    local color = chance:color({ format = "hex" })
    assert(type(color) == "string", tip)
    assert(string.len(color) == 7, tip)
    assert(string.match(color, "#[%l%d]+") == color, tip)
end)

tip = 'color() returns what looks like a gray scale hex color'
Helper.times_f(function()
    local color = chance:color({ format = "hex", grayscale = true })
    assert(type(color) == "string", tip)
    assert(string.len(color) == 7, tip)
    assert(string.match(color, "#[%l%d]+") == color, tip)
    assert(string.sub(color, 2, 3) == string.sub(color, 4, 5), tip)
    assert(string.sub(color, 2, 3) == string.sub(color, 6, 7), tip)
end)

tip = 'color() returns a short hex color'
Helper.times_f(function()
    local color = chance:color({ format = "shorthex" })
    assert(type(color) == "string", tip)
    assert(string.len(color) == 4, tip)
    assert(string.match(color, "#[%l%d]+") == color, tip)
end)
tip = 'color() returns what looks like a grayscale short hex color'
Helper.times_f(function()
    local color = chance:color({ format = "shorthex", grayscale = true })
    assert(type(color) == "string", tip)
    assert(string.len(color) == 4, tip)
    assert(string.sub(color, 2, 2) == string.sub(color, 3, 3), tip)
    assert(string.sub(color, 2, 2) == string.sub(color, 4, 4), tip)
    assert(string.match(color, "#[%l%d]+") == color, tip)
end)

tip = 'color() returns what looks like an rgb color'
Helper.times_f(function()
    local color = chance:color({ format = "rgb" })
    assert(type(color) == "string", tip)
    local c1, c2, c3 = string.match(color, "rgb%((%d+),(%d+),(%d+)%)")
    c1 = tonumber(c1)
    c2 = tonumber(c2)
    c3 = tonumber(c3)
    assert(c1 and c2 and c3 and c1 >= 0 and c1 <= 255 and c2 >= 0 and
            c2 <= 255 and c3 >= 0 and c3 <= 255, tip)
end)

tip = 'color() returns what looks like a grayscale rgb color'
Helper.times_f(function()
    local color = chance:color({ format = "rgb", grayscale = true })
    assert(type(color) == "string", tip)
    local c1, c2, c3 = string.match(color, "rgb%((%d+),(%d+),(%d+)%)")
    c1 = tonumber(c1)
    c2 = tonumber(c2)
    c3 = tonumber(c3)
    assert(c1 and c2 and c3 and c1 >= 0 and c1 <= 255 and c2 == c1 and c3 == c1, tip)
end)

tip = 'color() returns what looks like an rgba color'
Helper.times_f(function()
    local color = chance:color({ format = "rgba" })
    assert(type(color) == "string", tip)
    local c1, c2, c3, c4 = string.match(color, "rgba%((%d+),(%d+),(%d+),([01]%.?%d*)%)")
    c1 = tonumber(c1)
    c2 = tonumber(c2)
    c3 = tonumber(c3)
    c4 = tonumber(c4)
    assert(c1 and c2 and c3 and c4, tip)
    assert(c1 >= 0 and c1 <= 255 and c2 >= 0 and c2 <= 255 and c3 >= 0 and
            c3 <= 255 and c4 >= 0 and c4 <= 1, tip)
end)

tip = 'color() returns what looks like a grayscale rgba color'
Helper.times_f(function()
    local color = chance:color({ format = "rgba", grayscale = true })
    assert(type(color) == "string", tip)
    local c1, c2, c3, c4 = string.match(color, "rgba%((%d+),(%d+),(%d+),([01]%.?%d*)%)")
    c1 = tonumber(c1)
    c2 = tonumber(c2)
    c3 = tonumber(c3)
    c4 = tonumber(c4)
    assert(c1 and c2 and c3 and c4, tip)
    assert(c1 >= 0 and c1 <= 255 and c2 >= 0 and c2 <= 255 and c3 >= 0 and
            c3 <= 255, tip)
    assert(c1 == c2 and c1 == c3, tip)
    assert(c4 >= 0 and c4 <= 1, tip)
end)

tip = 'color() 0x color works'
Helper.times_f(function()
    local color = chance:color({ format = "0x" })
    assert(type(color) == "string", tip)
    assert(string.len(color) == 8, tip)
    assert(string.match(color, "0x[%l%d]+") == color, tip)
end)

tip = 'color() with name returns a valid color name'
Helper.times_f(function()
    local color = chance:color({ format = "name" })
    assert(type(color) == "string", tip)
end)

tip = 'color() upper case returns upper cased color'
Helper.times_f(function()
    local color = chance:color({ format = "hex", casing = "upper" })
    assert(type(color) == "string", tip)
    assert(string.len(color) == 7, tip)
    local str = string.sub(color, 1, 6)
    assert(string.upper(str) == str, tip)
end)

tip = 'color() bogus format throws error'
local fn = function()
    chance:color({ format = "banana" })
end
assert(not(pcall(fn)), tip)

tip = 'domain() returns a domain'
Helper.times_f(function()
    local domain = chance:domain()
    assert(type(domain) == "string", tip)
    assert(#Helper.split(domain, "%.") > 1, tip)
end)

tip = 'domain() obeys tld, if specified'
Helper.times_f(function()
    local domain = chance:domain({ tld = "com" })
    assert(type(domain) == "string", tip)
    assert(Helper.split(domain, "%.")[2] == "com", tip)
end)

tip = 'email() returns what looks like an email'
Helper.times_f(function()
    local email = chance:email()
    assert(type(email) == "string", tip)
    assert(#Helper.split(email, "@") > 1, tip)
end)

tip = 'email() obeys domain, if specified'
Helper.times_f(function()
    local email = chance:email({ domain = "victorquinn.com" })
    assert(type(email) == "string", tip)
    assert(Helper.split(email, "@")[2] == "victorquinn.com", tip)
end)

tip = 'email() has a leng specified, should generate string before domain with equal length'
Helper.times_f(function()
    local email = chance:email({ length = 5 })
    assert(string.len(Helper.split(email, "@")[1]) == 5, tip)
end)

tip = 'fbid() returns what looks like a Facebook id'
Helper.times_f(function()
    local fbid = chance:fbid()
    assert(type(fbid) == "string", tip)
    assert(string.len(fbid) == 16, tip)
end)

tip = 'google_analytics() returns what looks like a valid tracking code'
Helper.times_f(function()
    local tracking_code = chance:google_analytics()
    assert(type(tracking_code) == "string", tip)
    assert(string.len(tracking_code) == 12, tip)
    assert(string.find(tracking_code, "UA-"), tip)
end)

tip = 'hashtag() returns what looks like a hashtag'
Helper.times_f(function()
    local hashtag = chance:hashtag()
    assert(type(hashtag) == "string", tip)
    assert(string.match(hashtag, "^#[%w_]+$") == hashtag, tip)
end)

tip = 'ip() returns what looks like an IP address'
Helper.times_f(function()
    local ip = chance:ip()
    assert(type(ip) == "string", tip)
    assert(#Helper.split(ip, "%.") == 4, tip)
    assert(string.match(ip, "%d+%.%d+%.%d+%.%d+") == ip, tip)
end)

tip = 'ipv6() returns what looks like an IP address (v6)'
Helper.times_f(function()
    local ipv6 = chance:ipv6()
    assert(type(ipv6) == "string", tip)
    assert(#Helper.split(ipv6, ":") == 8, tip)
    assert(string.match(ipv6,
        "[a-f%d]+:[a-f%d]+:[a-f%d]+:[a-f%d]+:[a-f%d]+:[a-f%d]+:[a-f%d]+:[a-f%d]+") == ipv6, tip)
end)

tip = 'klout() returns what looks like a legit Klout score'
Helper.times_f(function()
    local klout = chance:klout()
    assert(type(klout) == "number", tip)
    assert(klout > 0 and klout <= 100, tip)
end)

tip = 'locale() should create a valid two character locale with only language'
Helper.times_f(function()
    local locale = chance:locale()
    assert(type(locale) == "string", tip)
    assert(string.len(locale) == 2, tip)
end)

tip = 'locale() should create a locale with a region code'
Helper.times_f(function()
    local locale = chance:locale({ region = true })
    assert(type(locale) == "string", tip)
    assert(#Helper.split(locale, "%-") >= 2, tip)
end)

tip = 'mac() returns what looks like an MAC address (EUI-48)'
Helper.times_f(function()
    local mac = chance:mac()
    assert(type(mac) == "string", tip)
    assert(#Helper.split(mac, ":") == 6, tip)
    assert(string.match(mac,
        "^[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]$") ==
        mac, tip)
end)

tip = 'mac() uses delimiter option for MAC address'
Helper.times_f(function()
    local del = { ':', '-', '.' }
    local delimiter = del[math.random(1, #del)]
    local mac = chance:mac({ delimiter = delimiter })
    assert(type(mac) == "string", tip)
    assert(#Helper.split(mac, "%"..delimiter) == 6, tip)
    local format = "^[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]:[%da-f][%da-f]$"
    format = string.gsub(format, ":", "%%" .. delimiter)
    assert(string.match(mac, format) == mac, tip)
end)

tip = 'port() should create a number in the valid port range (0 - 65535)'
Helper.times_f(function()
    local port = chance:port()
    assert(type(port) == "number", tip)
    assert(port >= 0 and port <= 65535, tip)
end)

tip = 'semver() works as expected'
Helper.times_f(function()
    local semver = chance:semver()
    assert(type(semver) == "string", tip)
    assert(string.find(semver, "%d+%.%d+%.%d+"), tip)
end)

tip = 'semver() accepts a range'
Helper.times_f(function()
    local semver = chance:semver({ range = "banana" })
    assert(type(semver) == "string", tip)
    assert(string.find(semver, "^banana%d+%.%d+%.%d+"), tip)
    local prerelease = string.match(semver, "banana%d+%.%d+%.%d+%-?(%w+)?")
    assert((prerelease and prerelease == "dev" or prerelease == "beta" or prerelease == "alpha") or
            not(prerelease), tip)
end)


tip = 'tld() returns a tld'
Helper.times_f(function()
    local tld = chance:tld()
    assert(type(tld) == "string", tip)
    assert(string.len(tld) < 6, tip)
end)

tip = 'twitter() returns what looks like a Twitter handle'
Helper.times_f(function()
    local twitter = chance:twitter()
    assert(type(twitter) == "string", tip)
    assert(string.match(twitter, "@[%u%l]+") == twitter, tip)
end)

tip = 'url() deal with url'
Helper.times_f(function()
    local url = chance:url()
    assert(type(url) == "string", tip)
    assert(#Helper.split(url, "%.") > 1, tip)
    assert(#Helper.split(url, "://") > 1, tip)
end)

tip = 'url() can take and respect a domain'
Helper.times_f(function()
    local url = chance:url({ domain = "victorquinn.com" })
    assert(type(url) == "string", tip)
    assert(#Helper.split(url, "%.") > 1, tip)
    assert(#Helper.split(url, "://") > 1, tip)
    assert(#Helper.split(url, "victorquinn.com") > 1, tip)
end)

tip = 'url() can take and respect a domain prefix'
Helper.times_f(function()
    local url = chance:url({ domain_prefix = "www" })
    assert(type(url) == "string", tip)
    assert(#Helper.split(url, "%.") > 1, tip)
    assert(#Helper.split(url, "://") > 1, tip)
    assert(#Helper.split(url, "www") > 1, tip)
end)

tip = 'url() can take and respect a path'
Helper.times_f(function()
    local url = chance:url({ path = "images" })
    assert(type(url) == "string", tip)
    assert(#Helper.split(url, "%.") > 1, tip)
    assert(#Helper.split(url, "://") > 1, tip)
    assert(#Helper.split(url, "/images") > 1, tip)
end)

tip = 'url() can take and respect extensions'
Helper.times_f(function()
    local url = chance:url({ extensions = { "html" } })
    assert(type(url) == "string", tip)
    assert(#Helper.split(url, "%.") > 1, tip)
    assert(#Helper.split(url, "://") > 1, tip)
    assert(string.find(url, "%.html"), tip)
end)

tip = 'lorem_picsum() returns lorem_picsum url with default width and height'
Helper.times_f(function()
    local lorem_picsum_url = chance:lorem_picsum()
    assert(type(lorem_picsum_url) == "string", tip)
    assert(#Helper.split(lorem_picsum_url, "%.") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "://") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "picsum%.photos") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/500/500") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/%?random") > 1, tip)
end)

tip = 'lorem_picsum() returns lorem_picsum url that respects width and height'
Helper.times_f(function()
    local width = chance:natural()
    local height = chance:natural()
    local lorem_picsum_url = chance:lorem_picsum({
        width = width, height = height,
    })
    assert(type(lorem_picsum_url) == "string", tip)
    assert(#Helper.split(lorem_picsum_url, "%.") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "://") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "picsum%.photos") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/" .. width .. "/" .. height) > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/%?random") > 1, tip)
end)

tip = 'lorem_picsum() returns lorem_picsum url that respects greyscale'
Helper.times_f(function()
    local lorem_picsum_url = chance:lorem_picsum({
        greyscale = true,
    })
    assert(type(lorem_picsum_url) == "string", tip)
    assert(#Helper.split(lorem_picsum_url, "%.") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "://") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "picsum%.photos") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/g/500/500") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/%?random") > 1, tip)
end)

tip = 'lorem_picsum() returns lorem_picsum url that respects blurred'
Helper.times_f(function()
    local lorem_picsum_url = chance:lorem_picsum({
        blurred = true,
    })
    assert(type(lorem_picsum_url) == "string", tip)
    assert(#Helper.split(lorem_picsum_url, "%.") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "://") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "picsum%.photos") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/500/500") > 1, tip)
    assert(#Helper.split(lorem_picsum_url, "/%?blur") > 1, tip)
end)

print("-------->>>>>>>> web test ok <<<<<<<<--------", os.clock() - t1)
