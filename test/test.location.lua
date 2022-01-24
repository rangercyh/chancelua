local Helper = require "utils.helper"
local Chance = require "chance"

local chance = Chance.new()
--[=[
local tip = 'address() returns a string'
assert(type(chance:address) == "string", tip)

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
    assert(string.match(areacode, "^%([2-9][0-8][0-9]%)$") == areacode, tip)
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
    local latitude = chance:latitude({ format = "dds" })
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
    local longitude = chance:longitude({ format = "dds" })
    assert(type(longitude) == "string", tip)
    assert(string.find(longitude, "[°]"), tip)
    assert(string.find(longitude, "[’]"), tip)
    assert(string.find(longitude, "[”]"), tip)
end)

]=]
tip = 'phone() returns a string'
assert(type(chance:phone()) == "string", tip)

tip = 'phone() looks like an actual phone number'
local phone = chance:phone()
assert(string.match(phone, "^%([2-9][0-8][0-9]%)?[%-. ]?[0-9]+[%-. ]?[0-9]+$") == phone, tip)

tip = 'phone() obeys formatted option'
Helper.thousand_times_f(function()
    local phone = chance:phone({ formatted = false })
    assert(type(phone) == "string", tip)
    print(phone)
    assert(string.match(phone, "^[2-9][0-8]%d[2-9]%d+$") == phone, tip)
end)

tip = 'phone() obeys formatted option and parens option'
Helper.thousand_times_f(function()
    local phone = chance:phone({ formatted = false, parens = true })
    assert(type(phone) == "string", tip)
    assert(string.match(phone, "^[2-9][0-8]%d[2-9]%d+$") == phone, tip)
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
    assert(string.match(phone, "^555[2-9]%d+$") == phone, tip)
end)

tip = 'phone() with uk option works'
assert(type(chance:phone({ country = "uk" })) == "string", tip)

tip = 'phone() with uk option works and mobile option'
assert(type(chance:phone({ country = "uk", mobile = true })) == "string", tip)

--[=[
tip = 'phone() with uk country looks right'
assert()
    t.true(phoneNumber.isValid(chance.phone({ country: 'uk' })))
})

test('phone() with uk country unformatted looks right', t => {
    t.true(phoneNumber.isValid(phoneNumber.format(chance.phone({
        country: 'uk',
        formatted: false
    }))))
})

test('phone() with uk country and mobile option looks right', t => {
    _.times(1000, () => {
        t.true(phoneNumber.isValid(chance.phone({
            country: 'uk',
            mobile: true
        })))
    })
})

test('phone() with uk country and mobile option unformatted looks right', t => {
    _.times(1000, () => {
        t.true(phoneNumber.isValid(phoneNumber.format(chance.phone({
            country: 'uk',
            mobile: true,
            formatted: false
        }))))
    })
})

test('phone() with fr country works', t => {
    t.true(_.isString(chance.phone({ country: 'fr' })))
})

test('phone() with fr country works with mobile option', t => {
    t.true(_.isString(chance.phone({ country: 'fr', mobile: true })))
})

test('phone() with fr country looks right', t => {
    _.times(1000, () => {
        t.true(/0[123459] .. .. .. ../.test(chance.phone({ country: 'fr' })))
    })
})

test('phone() with fr country looks right unformatted', t => {
    _.times(1000, () => {
        t.true(/0........./.test(chance.phone({
            country: 'fr',
            formatted: false
        })))
    })
})

test('phone() with fr country on mobile looks right', t => {
    _.times(1000, () => {
        t.true(/0[67] .. .. .. ../.test(chance.phone({
            country: 'fr',
            mobile: true
        })))
    })
})

test('phone() with fr country on mobile, unformatted looks right', t => {
    _.times(1000, () => {
        t.true(/0[67]......../.test(chance.phone({
            country: 'fr',
            mobile: true,
            formatted: false
        })))
    })
})

test('phone() with br country option works', t => {
    t.true(_.isString(chance.phone({ country: 'br' })))
})

test('phone() with br country and mobile option works', t => {
    t.true(_.isString(chance.phone({ country: 'br', mobile: true })))
})

test('phone() with br country and formatted false option return a correct format', t => {
    t.true(/([0-9]{2})([2-5]{1})([0-9]{3})([0-9]{4})/.test(chance.phone({
        country: 'br',
        mobile: false,
        formatted: false
    })))
})

test('phone() with br country, formatted false and mobile option return a correct format', t => {
    t.true(/([0-9]{2})\9([0-9]{4})([0-9]{4})/.test(chance.phone({
        country: 'br',
        mobile: true,
        formatted: false
    })))
})

test('phone() with br country and formatted option apply the correct mask', t => {
    t.true(/\(([0-9]{2})\) ([2-5]{1})([0-9]{3})\-([0-9]{4})/.test(chance.phone({
        country: 'br',
        mobile: false,
        formatted: true
    })))
})

test('phone() with br country, formatted and mobile option apply the correct mask', t => {
    t.true(/\(([0-9]{2})\) 9([0-9]{4})\-([0-9]{4})/.test(chance.phone({
        country: 'br',
        mobile: true,
        formatted: true
    })))
})

// chance.postal()
test('postal() returns a valid basic postal code', t => {
    _.times(1000, () => {
        let postal = chance.postal()
        t.is(postal.length, 7)
        postal.split('').map((char) => {
            t.is(char.toUpperCase(), char)
        })
    })
})

test('postcode() returns a valid basic postcode', t => {
    _.times(10, () => {
        let postcode = chance.postcode();
        t.regex(postcode, /^[A-Z]{1,2}\d[A-Z\d]? \d[A-Z]{2}$/);
    })
})

// chance.province()
test('province() returns a random (short) province name', t => {
    _.times(1000, () => t.true(chance.province().length < 3))
})

test('province() can return a long random province name', t => {
    _.times(1000, () => t.true(chance.province({ full: true }).length > 2))
})

test('province() can return a random long "it" province', t => {
    _.times(1000, () => {
        t.true(chance.province({country: 'it', full: true }).length > 2)
    })
})

// chance.provinces()
test('provinces() returns an array of provinces', t => {
    t.true(_.isArray(chance.provinces()))
})

test('provinces() supports internationalization', t => {
    t.not(chance.provinces(), chance.provinces({ country: 'it' }))
})

// chance.state()
test('state() returns a random (short) state name', t => {
    _.times(1000, () => t.true(chance.state().length < 3))
})

test('state() can take a country and return a state', t => {
    _.times(1000, () => t.true(chance.state({ country: 'it' }).length === 3))
})

test('state() can return full state name', t => {
    _.times(1000, () => {
        t.true(chance.state({
            full: true
        }).length > 2)
    })
})

test('state() with country returns a long state name', t => {
    _.times(1000, () => {
        t.true(chance.state({
            country: 'it',
            full: true
        }).length > 2)
    })
    _.times(1000, () => {
        t.true(chance.state({
            country: 'uk',
            full: true
        }).length > 2)
    })
})

// chance.states()
test('states() returns an array of states', t => {
    t.true(_.isArray(chance.states()))
})

test('states() returns all 50 states and DC', t => {
    t.is(chance.states().length, 51)
})

test('states() with territories returns 50 US states, DC, and 7 US territories', t => {
    t.is(chance.states({
        territories: true
    }).length, 58)
})

test('states() without us states and dc returns 7 US territories', t => {
    t.is(chance.states({
        territories: true,
        us_states_and_dc: false
    }).length, 7)
})

test('states() with armed forces returns 50 states, DC, and 3 armed forces military states', t => {
    t.is(chance.states({
        armed_forces: true
    }).length, 54)
})

test('states() with armed forces without states returns 3 armed forces states', t => {
    t.is(chance.states({
        armed_forces: true,
        us_states_and_dc: false
    }).length, 3)
})

test('states() with all options returns 61 items', t => {
    t.is(chance.states({
        territories: true,
        armed_forces: true
    }).length, 61)
})

test('states() without states returns 7 territories and 3 armed forces states', t => {
    t.is(chance.states({
        territories: true,
        armed_forces: true,
        us_states_and_dc: false
    }).length, 10)
})

test('states() with country of "it" returns 20 regions', t => {
    t.is(chance.states({
        country: 'it'
    }).length, 20)
})

test('states() with country of "uk" returns 129 UK counties', t => {
    t.is(chance.states({
        country: 'uk'
    }).length, 129)
})

test('states() with country of "mx" returns 32 MX states', t => {
    t.is(chance.states({
        country: 'mx'
    }).length, 32)
})

// chance.street()
test('street() works', t => {
    _.times(100, () => t.is(typeof chance.street(), 'string'))
})

test('street() works with it country', t => {
    _.times(100, () => t.is(typeof chance.street({ country: 'it' }), 'string'))
})

// chance.street_suffix()
test('street_suffix() returns a single suffix', t => {
    _.times(1000, () => {
        let suffix = chance.street_suffix()
        t.is(typeof suffix, 'object')
        t.is(typeof suffix.name, 'string')
        t.is(typeof suffix.abbreviation, 'string')
    })
})

// chance.street_suffixes()
test('street_suffixes() returns the suffix array', t => {
    let suffixes = chance.street_suffixes()
    t.true(_.isArray(suffixes))
    suffixes.map((suffix) => {
        t.truthy(suffix.name)
        t.truthy(suffix.abbreviation)
    })
})

test('street_suffixes() are short', t => {
    let suffixes = chance.street_suffixes()
    suffixes.map((suffix) => {
        t.true(suffix.abbreviation.length < 5)
    })
})

test('street_suffixes() are longish', t => {
    let suffixes = chance.street_suffixes()
    suffixes.map((suffix) => {
        t.true(suffix.name.length > 2)
    })
})

// chance.zip()
test('zip() returns a valid basic zip code', t => {
    _.times(1000, () => {
        let zip = chance.zip()
        t.is(zip.length, 5)
        t.true(/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(zip))
    })
})

test('zip() returns a valid zip+4 code', t => {
    _.times(1000, () => {
        let zip = chance.zip({ plusfour: true })
        t.is(zip.length, 10)
        t.true(/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(zip))
    })
})

print("-------->>>>>>>> location test ok <<<<<<<<--------")

--]=]

