local Helper = require "utils.helper"
local Chance = require "chance"

local chance = Chance.new()
local tip = 'address() returns a string'
assert(type(chance:address()) == "string", tip)

tip = 'address() starts with a number'
Helper.thousand_times_f(function()
    local addr = chance:address()
    assert(string.match(addr, "^%d+.+") == addr, tip)
end)

tip = 'address() can take a short_suffix arg and obey it'
Helper.thousand_times_f(function()
    local addr = chance:address({ short_suffix = true })
    local t = Helper.split(addr, " ")
    assert(string.len(t[#t]) < 5, tip)
end)
tip = 'altitude() looks right'
assert(type(chance:altitude()) == "number", tip)

tip = 'altitude() is in the right range'
Helper.thousand_times_f(function()
    local altitude = chance:altitude()
    assert(altitude > 0 and altitude < 8848, tip)
end)

tip = 'altitude() will accept a min and obey it'
Helper.thousand_times_f(function()
    local min = chance:floating({ min = 0, max = 8848 })
    local altitude = chance:altitude({ min = min })
    assert(altitude > min and altitude < 8848, tip)
end)

tip = 'altitude() will accept a max and obey it'
Helper.thousand_times_f(function()
    local max = chance:floating({ min = 0, max = 8848 })
    local altitude = chance:altitude({ max = max })
    assert(altitude > 0 and altitude < max, tip)
end)

tip = 'areacode() looks right'
Helper.thousand_times_f(function()
    local areacode = chance:areacode()
    assert(type(areacode) == "string", tip)
    assert(string.match(areacode, "^%([2-9][0-8][0-9]%)$") == areacode, tip)
end)

tip = 'areacode() can take parens'
Helper.thousand_times_f(function()
    local areacode = chance:areacode({ parens = false })
    assert(type(areacode) == "string", tip)
    assert(string.match(areacode, "^[2-9][0-8][0-9]$") == areacode, tip)
end)

tip = 'city() looks right'
Helper.thousand_times_f(function()
    local city = chance:city()
    assert(type(city) == "string", tip)
    assert(string.match(city, "[%l%u]+") == city, tip)
end)

tip = 'coordinates() looks right'
Helper.thousand_times_f(function()
    local coordinates = chance:coordinates()
    assert(type(coordinates) == "string", tip)
    assert(#Helper.split(coordinates, ",") == 2, tip)
end)

tip = 'coordinates() returns coordinates in DD format as default'
Helper.thousand_times_f(function()
    local CHARS_NOT_TO_CONTAIN = "[°’”]"
    local coordinates = chance:coordinates()
    local t = Helper.split(coordinates, ",")
    assert(type(coordinates) == "string", tip)
    assert(#t == 2, tip)
    for i = 1, 2 do
        assert(not(string.find(t[i], CHARS_NOT_TO_CONTAIN)), tip)
    end
end)

tip = 'coordinates() will obey DD format'
Helper.thousand_times_f(function()
    local CHARS_NOT_TO_CONTAIN = "[°’”]"
    local coordinates = chance:coordinates({ format = "dd" })
    local t = Helper.split(coordinates, ",")
    assert(type(coordinates) == "string", tip)
    assert(#t == 2, tip)
    for i = 1, 2 do
        assert(not(string.find(t[i], CHARS_NOT_TO_CONTAIN)), tip)
    end
end)

tip = 'coordinates() will obey DDM format'
Helper.thousand_times_f(function()
    local CHARS_TO_CONTAIN = "[°]"
    local CHARS_NOT_TO_CONTAIN = "[’”]"
    local coordinates = chance:coordinates({ format = "ddm" })
    local t = Helper.split(coordinates, ",")
    assert(type(coordinates) == "string", tip)
    assert(#t == 2, tip)
    for i = 1, 2 do
        assert(string.find(t[i], CHARS_TO_CONTAIN), tip)
        assert(not(string.find(t[i], CHARS_NOT_TO_CONTAIN)), tip)
    end
end)

tip = 'coordinates() will obey DMS format'
Helper.thousand_times_f(function()
    local coordinates = chance:coordinates({ format = "dms" })
    local t = Helper.split(coordinates, ",")
    assert(type(coordinates) == "string", tip)
    assert(#t == 2, tip)
    for i = 1, 2 do
        assert(string.find(t[i], "°"), tip)
        assert(string.find(t[i], "’"), tip)
        assert(string.find(t[i], "”"), tip)
    end
end)


tip = 'country() returns a random (short) country name'
Helper.thousand_times_f(function()
    assert(string.len(chance:country()) == 2, tip)
end)

tip = 'country() returns a random (long) country name'
Helper.thousand_times_f(function()
    assert(string.len(chance:country({ full = true })) > 2, tip)
end)

tip = 'county() returns a random county name'
Helper.thousand_times_f(function()
    assert(type(chance:country()) == "string", tip)
end)

tip = 'depth() looks right'
assert(type(chance:depth()) == "number", tip)

tip = 'depth() is in the right range'
Helper.thousand_times_f(function()
    local depth = chance:depth()
    assert(depth > -10994 and depth < 0, tip)
end)

tip = 'depth() will accept a min and obey it'
Helper.thousand_times_f(function()
    local min = chance:floating({ min = -10094, max = 0 })
    local depth = chance:depth({ min = min })
    assert(depth > min and depth < 0, tip)
end)

tip = 'depth() will accept a max and obey it'
Helper.thousand_times_f(function()
    local max = chance:floating({ min = -10094, max = 0 })
    local depth = chance:depth({ max = max })
    assert(depth > -10994 and depth < max, tip)
end)

tip = 'geohash() looks right'
local geohash = chance:geohash()
assert(type(geohash) == "string", tip)
assert(string.len(geohash) == 7, tip)

tip = 'geohash() will accept a length and obey it'
Helper.thousand_times_f(function()
    local length = chance:d10()
    local geohash = chance:geohash({ length = length })
    assert(string.len(geohash) == length, tip)
end)

tip = 'latitude() looks right'
assert(type(chance:latitude()) == "number", tip)

tip = 'latitude() is in the right range'
Helper.thousand_times_f(function()
    local latitude = chance:latitude()
    assert(latitude >= -90 and latitude <= 90, tip)
end)

tip = 'latitude() will accept a min and obey it'
Helper.thousand_times_f(function()
    local min = chance:floating({ min = -90, max = 90 })
    local latitude = chance:latitude({ min = min })
    assert(latitude >= min and latitude <= 90, tip)
end)

tip = 'latitude() will accept a max and obey it'
Helper.thousand_times_f(function()
    local max = chance:floating({ min = -90, max = 90 })
    local latitude = chance:latitude({ max = max })
    assert(latitude >= -90 and latitude <= max, tip)
end)

tip = 'latitude() returns latitude in DD format as default'
Helper.thousand_times_f(function()
    local latitude = chance:latitude()
    assert(type(latitude) == "number", tip)
    assert(not(string.find(tostring(latitude), "[°’”]")), tip)
end)

tip = 'latitude() will obey DD format'
Helper.thousand_times_f(function()
    local latitude = chance:latitude({ format = "dd" })
    assert(type(latitude) == "number", tip)
    assert(not(string.find(tostring(latitude), "[°’”]")), tip)
end)

tip = 'latitude() will obey DDM format'
Helper.thousand_times_f(function()
    local latitude = chance:latitude({ format = "ddm" })
    assert(type(latitude) == "string", tip)
    assert(string.find(tostring(latitude), "[°]"), tip)
    assert(not(string.find(tostring(latitude), "[’”]")), tip)
end)

tip = 'latitude() will obey DMS format'
Helper.thousand_times_f(function()
    local latitude = chance:latitude({ format = "dms" })
    assert(type(latitude) == "string", tip)
    assert(string.find(tostring(latitude), "[°]"), tip)
    assert(string.find(tostring(latitude), "[’]"), tip)
    assert(string.find(tostring(latitude), "[”]"), tip)
end)

tip = 'longitude() looks right'
assert(type(chance:longitude()) == "number", tip)

tip = 'longitude() is in the right range'
Helper.thousand_times_f(function()
    local longitude = chance:longitude()
    assert(longitude >= -180 and longitude <= 180, tip)
end)

tip = 'longitude() will accept a min and obey it'
Helper.thousand_times_f(function()
    local min = chance:floating({ min = -180, max = 180 })
    local longitude = chance:longitude({ min = min })
    assert(longitude >= min and longitude <= 180, tip)
end)

tip = 'longitude() will accept a max and obey it'
Helper.thousand_times_f(function()
    local max = chance:floating({ min = -180, max = 180 })
    local longitude = chance:longitude({ max = max })
    assert(longitude >= -180 and longitude <= max, tip)
end)

tip = 'longitude() returns longitude in DD format as default'
Helper.thousand_times_f(function()
    local longitude = chance:longitude()
    assert(type(longitude) == "number", tip)
    assert(not(string.find(tostring(longitude), "[°’”]")), tip)
end)

tip = 'longitude() will obey DD format'
Helper.thousand_times_f(function()
    local longitude = chance:longitude({ format = "dd" })
    assert(type(longitude) == "number", tip)
    assert(not(string.find(tostring(longitude), "[°’”]")), tip)
end)

tip = 'longitude() will obey DDM format'
Helper.thousand_times_f(function()
    local longitude = chance:longitude({ format = "ddm" })
    assert(type(longitude) == "string", tip)
    assert(string.find(longitude, "[°]"), tip)
    assert(not(string.find(longitude, "[’”]")), tip)
end)

tip = 'longitude() will obey DMS format'
Helper.thousand_times_f(function()
    local longitude = chance:longitude({ format = "dms" })
    assert(type(longitude) == "string", tip)
    assert(string.find(longitude, "[°]"), tip)
    assert(string.find(longitude, "[’]"), tip)
    assert(string.find(longitude, "[”]"), tip)
end)

tip = 'phone() returns a string'
assert(type(chance:phone()) == "string", tip)

tip = 'phone() looks like an actual phone number'
local phone = chance:phone()
assert(string.match(phone, "^%([2-9][0-8][0-9]%)?[%-. ]?[0-9]+[%-. ]?[0-9]+$") == phone, tip)

tip = 'phone() obeys formatted option'
Helper.thousand_times_f(function()
    local phone = chance:phone({ formatted = false })
    assert(type(phone) == "string", tip)
    assert(string.match(phone, "^[2-9][0-8]%d[2-9]%d%d%d%d%d%d$") == phone, tip)
end)

tip = 'phone() obeys formatted option and parens option'
Helper.thousand_times_f(function()
    local phone = chance:phone({ formatted = false, parens = true })
    assert(type(phone) == "string", tip)
    assert(string.match(phone, "^[2-9][0-8]%d[2-9]%d%d%d%d%d%d$") == phone, tip)
end)

tip = "phone() obeys exampleNumber option"
Helper.thousand_times_f(function()
    local phone = chance:phone({ example_number = true })
    assert(type(phone) == "string", tip)
    assert(string.match(phone, "^%(555%)?[%-. ]?[2-9][0-9]+[%- ]?[0-9]+$") == phone, tip)
end)

tip = "phone() obeys formatted option and exampleNumber option"
Helper.thousand_times_f(function()
    local phone = chance:phone({ example_number = true, formatted = false })
    assert(type(phone) == "string", tip)
    assert(string.match(phone, "^555[2-9]%d%d%d%d%d%d$") == phone, tip)
end)

tip = 'phone() with uk option works'
assert(type(chance:phone({ country = "uk" })) == "string", tip)

tip = 'phone() with uk option works and mobile option'
assert(type(chance:phone({ country = "uk", mobile = true })) == "string", tip)

tip = 'phone() with uk country looks right'
assert(Helper.phone_vaild(chance:phone({ country = "uk" })), tip)

tip = 'phone() with uk country unformatted looks right'
assert(Helper.phone_vaild(Helper.phone_format(chance:phone({
    country = "uk",
    formatted = false,
}))), tip)

tip = 'phone() with uk country and mobile option looks right'
Helper.thousand_times_f(function()
    local phone = chance:phone({
        country = "uk",
        mobile = true,
    })
    assert(Helper.phone_vaild(phone), tip)
end)

tip = 'phone() with uk country and mobile option unformatted looks right'
Helper.thousand_times_f(function()
    assert(Helper.phone_vaild(Helper.phone_format(chance:phone({
        country = "uk",
        mobile = true,
        formatted = false,
    }))), tip)
end)

tip = 'phone() with fr country works'
assert(type(chance:phone({ country = "fr" })) == "string", tip)

tip = 'phone() with fr country works with mobile option'
assert(type(chance:phone({ country = "fr", mobile = true })), tip)

tip = 'phone() with fr country looks right'
Helper.thousand_times_f(function()
    local phone = chance:phone({ country = "fr" })
    assert(string.match(phone, "0[123459] .. .. .. ..") == phone, tip)
end)

tip = 'phone() with fr country looks right unformatted'
Helper.thousand_times_f(function()
    local phone = chance:phone({ country = "fr", formatted = false })
    assert(string.match(phone, "0.........") == phone, tip)
end)

tip = 'phone() with fr country on mobile looks right'
Helper.thousand_times_f(function()
    local phone = chance:phone({ country = "fr", mobile = true })
    assert(string.match(phone, "0[67] .. .. .. ..") == phone, tip)
end)

tip = 'phone() with fr country on mobile, unformatted looks right'
Helper.thousand_times_f(function()
    local phone = chance:phone({ country = "fr", mobile = true, formatted = false })
    assert(string.match(phone, "0[67]........") == phone, tip)
end)

tip = 'phone() with br country option works'
assert(type(chance:phone({ country = "br" })), tip)

tip = 'phone() with br country and mobile option works'
assert(type(chance:phone({ country = "br", mobile = true })), tip)

tip = 'phone() with br country and formatted false option return a correct format'
local phone = chance:phone({ country = "br", mobile = false, formatted = false })
assert(string.match(phone, "%d%d[2-5]%d%d%d%d%d%d%d") == phone, tip)

tip = 'phone() with br country, formatted false and mobile option return a correct format'
local phone = chance:phone({ country = "br", mobile = true, formatted = false })
assert(string.match(phone, "%d%d9%d%d%d%d%d%d%d%d") == phone, tip)

tip = 'phone() with br country and formatted option apply the correct mask'
local phone = chance:phone({ country = "br", mobile = false, formatted = true })
assert(string.match(phone, "%(%d%d%) [2-5]%d%d%d%-%d%d%d%d") == phone, tip)

tip = 'phone() with br country, formatted and mobile option apply the correct mask'
Helper.thousand_times_f(function()
    local phone = chance:phone({ country = "br", mobile = true, formatted = true })
    assert(string.match(phone, "%(%d%d%) 9%d%d%d%d%-%d%d%d%d") == phone, tip)
end)

tip = 'postal() returns a valid basic postal code'
Helper.thousand_times_f(function()
    local postal = chance:postal()
    assert(string.len(postal) == 7, tip)
    for i = 1, 7 do
        local c = string.sub(postal, i, i)
        assert(string.upper(c) == c, tip)
    end
end)

tip = 'postcode() returns a valid basic postcode'
Helper.thousand_times_f(function()
    local postcode = chance:postcode()
    assert(string.match(postcode, "^%u%u?%d[%u%d]? %d%u%u$") == postcode, tip)
end)

tip = 'province() returns a random (short) province name'
Helper.thousand_times_f(function()
    assert(string.len(chance:province()) < 3, tip)
end)

tip = 'province() can return a long random province name'
Helper.thousand_times_f(function()
    assert(string.len(chance:province({ full = true })) > 2, tip)
end)

tip = 'province() can return a random long "it" province'
Helper.thousand_times_f(function()
    assert(string.len(chance:province({ country = "it", full = true })) > 2, tip)
end)

tip = 'state() returns a random (short) state name'
Helper.thousand_times_f(function()
    assert(string.len(chance:state()) < 3, tip)
end)

tip = 'state() can take a country and return a state'
Helper.thousand_times_f(function()
    assert(string.len(chance:state({ country = "it" })) == 3, tip)
end)

tip = 'state() can return full state name'
Helper.thousand_times_f(function()
    assert(string.len(chance:state({ full = true })) > 2, tip)
end)

tip = 'state() with country returns a long state name'
Helper.thousand_times_f(function()
    assert(string.len(chance:state({ country = "it", full = true })) > 2, tip)
    assert(string.len(chance:state({ country = "uk", full = true })) > 2, tip)
end)

tip = 'street() works'
Helper.thousand_times_f(function()
    assert(type(chance:street()) == "string", tip)
end)

tip = 'street() works with it country'
Helper.thousand_times_f(function()
    assert(type(chance:street({ country = "it" })) == "string", tip)
end)

tip = 'street_suffix() returns a single suffix'
Helper.thousand_times_f(function()
    local suffix = chance:street_suffix()
    assert(type(suffix) == "table", tip)
    assert(type(suffix.name) == "string", tip)
    assert(type(suffix.abbreviation) == "string", tip)
end)

tip = 'zip() returns a valid basic zip code'
Helper.thousand_times_f(function()
    local zip = chance:zip()
    assert(string.len(zip) == 5, tip)
    assert(string.match(zip, "^%d%d%d%d%d$") == zip or string.match(zip, "^%d%d%d%d%d%-%d%d%d%d$") == zip, tip)
end)

tip = 'zip() returns a valid zip+4 code'
Helper.thousand_times_f(function()
    local zip = chance:zip({ plusfour = true })
    assert(string.len(zip) == 10, tip)
    assert(string.match(zip, "^%d%d%d%d%d$") == zip or string.match(zip, "^%d%d%d%d%d%-%d%d%d%d$") == zip, tip)
end)

print("-------->>>>>>>> location test ok <<<<<<<<--------")

