local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

-- age constants
local CHILD_AGE_MIN = 0
local CHILD_AGE_MAX = 12
local TEEN_AGE_MIN = 13
local TEEN_AGE_MAX = 19
local ADULT_AGE_MIN = 18
local ADULT_AGE_MAX = 65
local SENIOR_AGE_MIN = 65
local SENIOR_AGE_MAX = 100
local AGE_MIN = 0
local AGE_MAX = 100

local cur_year = os.date("*t").year
tip = 'age() returns a random age within expected bounds'
Helper.times_f(function()
    local age = chance:age()
    assert(type(age) == "number", tip)
    assert(age >= ADULT_AGE_MIN and age <= ADULT_AGE_MAX, tip)
end)

tip = 'age() returns a random age within expected bounds for all'
Helper.times_f(function()
    local age = chance:age({ type = "all" })
    assert(type(age) == "number", tip)
    assert(age >= AGE_MIN and age <= AGE_MAX, tip)
end)

tip = 'age() returns a proper age for a child'
Helper.times_f(function()
    local age = chance:age({ type = "child" })
    assert(type(age) == "number", tip)
    assert(age >= CHILD_AGE_MIN and age <= CHILD_AGE_MAX, tip)
end)

tip = 'age() returns a proper age for a teen'
Helper.times_f(function()
    local age = chance:age({ type = "teen" })
    assert(type(age) == "number", tip)
    assert(age >= TEEN_AGE_MIN and age <= TEEN_AGE_MAX, tip)
end)

tip = 'age() returns a proper age for an adult'
Helper.times_f(function()
    local age = chance:age({ type = "adult" })
    assert(type(age) == "number", tip)
    assert(age >= ADULT_AGE_MIN and age <= ADULT_AGE_MAX, tip)
end)

tip = 'age() returns a proper age for a senior'
Helper.times_f(function()
    local age = chance:age({ type = "senior" })
    assert(type(age) == "number", tip)
    assert(age >= SENIOR_AGE_MIN and age <= SENIOR_AGE_MAX, tip)
end)

tip = 'birthday() works as expected'
Helper.times_f(function()
    local birthday = chance:birthday()
    assert(type(birthday) == "table", tip)
    local year = birthday.year
    local cur_year = os.date("*t").year
    assert(year > (cur_year - AGE_MAX) and year < cur_year, tip)
end)

tip = 'birthday() can have a str returned'
Helper.times_f(function()
    local birthday = chance:birthday({ str = true })
    assert(type(birthday) == "string", tip)
    assert(string.match(birthday, "%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d") == birthday, tip)
end)

tip = 'birthday() can have a year specified'
Helper.times_f(function()
    assert(chance:birthday({ year = 1983 }).year == 1983, tip)
end)

tip = 'birthday() can have an age range specified for an adult'
Helper.times_f(function()
    local birthday = chance:birthday({ type = "adult" })
    local cur_year = os.date("*t").year
    local min = os.time({
        year = cur_year - ADULT_AGE_MAX - 1,
        month = 1, day = 1, hour = 0, min = 0, sec = 0,
    })
    local max = os.time({
        year = cur_year - ADULT_AGE_MIN,
        month = 12, day = 31, hour = 23, min = 59, sec = 60,
    })
    local birthday_str = os.time(birthday)
    assert(birthday_str >= min and birthday_str <= max, tip)
end)

tip = 'birthday() can have an age range specified for a teen'
Helper.times_f(function()
    local birthday = chance:birthday({ type = "teen" })
    local cur_year = os.date("*t").year
    local min = os.time({
        year = cur_year - TEEN_AGE_MAX - 1,
        month = 1, day = 1, hour = 0, min = 0, sec = 0,
    })
    local max = os.time({
        year = cur_year - TEEN_AGE_MIN,
        month = 12, day = 31, hour = 23, min = 59, sec = 59,
    })
    local birthday_str = os.time(birthday)
    assert(birthday_str >= min and birthday_str <= max, tip)
end)

tip = 'birthday() can have an age range specified for a child'
Helper.times_f(function()
    local birthday = chance:birthday({ type = "child" })
    local cur_year = os.date("*t").year
    local min = os.time({
        year = cur_year - CHILD_AGE_MAX - 1,
        month = 1, day = 1, hour = 0, min = 0, sec = 0,
    })
    local max = os.time({
        year = cur_year - CHILD_AGE_MIN,
        month = 12, day = 31, hour = 23, min = 59, sec = 59,
    })
    local birthday_str = os.time(birthday)
    assert(birthday_str >= min and birthday_str <= max, tip)
end)

tip = 'birthday() can have an age range specified for a senior'
Helper.times_f(function()
    local birthday = chance:birthday({ type = "senior" })
    local cur_year = os.date("*t").year
    local min = os.time({
        year = cur_year - SENIOR_AGE_MAX - 1,
        month = 1, day = 1, hour = 0, min = 0, sec = 0,
    })
    local max = os.time({
        year = cur_year - SENIOR_AGE_MIN,
        month = 12, day = 31, hour = 23, min = 59, sec = 59,
    })
    local birthday_str = os.time(birthday)
    assert(birthday_str >= min and birthday_str <= max, tip)
end)

tip = 'company() returns a random company'
Helper.times_f(function()
    local company = chance:company()
    assert(type(company) == "string", tip)
    assert(string.len(company) > 4, tip)
end)

tip = 'cpf() returns a random valid taxpayer number for Brazil citizens (CPF)'
Helper.times_f(function()
    local cpf = chance:cpf()
    assert(type(cpf) == "string", tip)
    assert(string.match(cpf, "^%d%d%d.%d%d%d.%d%d%d%-%d%d$"), tip)
    assert(string.len(cpf) == 14, tip)
end)

tip = 'first() returns a random first name'
Helper.times_f(function()
    local first = chance:first()
    assert(type(first) == "string", tip)
    local len = string.len(first)
    assert(len >= 2 and len <= 20, tip)
    assert(#Helper.split(first, " ") == 1, tip)
end)

tip = 'gender() returns a random gender'
Helper.times_f(function()
    local gender = chance:gender()
    assert(gender == "Male" or gender == "Female", tip)
end)

tip = 'gender() can take extra genders'
Helper.times_f(function()
    local gender = chance:gender({ extra_genders = { "Unknown", "Transgender" } })
    assert(gender == "Male" or gender == "Female" or gender == "Unknown" or gender == "Transgender", tip)
end)

tip = 'HIDN() returns a random HIDN'
Helper.times_f(function()
    local hidn = chance:HIDN()
    assert(type(hidn) == "string", tip)
    assert(string.match(hidn, "^%d%d%d%d%d%d%u%u$") == hidn, tip)
    assert(string.len(hidn) == 8, tip)
end)

tip = 'israelId() returns a valid Isreal id'
local id = chance:israelId()
assert(type(id) == "string", tip)
assert(string.len(id) == 9, tip)
local acc = 0
for i = 1, 8 do
    local this_digit = tonumber(string.sub(id, i, i)) * (i % 2 == 0 and 1 or 2)
    this_digit = chance:pad(this_digit, 2)
    this_digit = tonumber(string.sub(this_digit, 1, 1), 10) + tonumber(string.sub(this_digit, 2, 2), 10)
    acc = acc + this_digit
end
acc = tostring(acc)
local last_digit = string.sub(tostring(10 - tonumber(string.sub(tostring(tonumber(string.sub(acc, -1), 10)), -1), 10)), -1)
assert(last_digit == string.sub(id, 9), tip)

tip = 'last() returns a random last name'
Helper.times_f(function()
    local last = chance:last()
    assert(type(last) == "string", tip)
    local len = string.len(last)
    assert(len >= 2 and len <= 20, tip)
    assert(#Helper.split(last, " ") <= 3, tip)
end)

tip = 'name() returns a random name'
Helper.times_f(function()
    local name = chance:name()
    assert(type(name) == "string", tip)
    local len = string.len(name)
    assert(len >= 2 and len <= 30, tip)
    assert(#Helper.split(name, " ") == 2, tip)
    assert(string.match(name, "[%u%l]+ [%u%l]+") == name, tip)
end)

tip = 'name() can have the middle name specified'
Helper.times_f(function()
    local name = chance:name({ middle = true })
    assert(type(name) == "string", tip)
    assert(#Helper.split(name, " ") == 3, tip)
    assert(string.match(name, "[%u%l]+ [%u%l]+ [%u%l]+") == name, tip)
end)

tip = 'name() can have the middle initial specified'
Helper.times_f(function()
    local name = chance:name({ middle_initial = true })
    assert(type(name) == "string", tip)
    assert(#Helper.split(name, " ") == 3, tip)
    assert(string.match(name, "[%u%l]+ [%u%l]%. [%u%l]+") == name, tip)
end)

tip = 'name() can have the prefix specified'
Helper.times_f(function()
    local name = chance:name({ prefix = true })
    assert(type(name) == "string", tip)
    assert(#Helper.split(name, " ") == 3, tip)
    assert(string.match(name, "[%u%l]+%.? [%u%l]+ [%u%l]+") == name, tip)
end)

tip = 'name() can have the suffix specified'
Helper.times_f(function()
    local name = chance:name({ suffix = true })
    assert(type(name) == "string", tip)
    assert(#Helper.split(name, " ") == 3, tip)
    assert(string.match(name, "[%u%l]+ [%u%l]+ [%u%l%.]+") == name, tip)
end)

tip = 'prefix() returns a random prefix'
Helper.times_f(function()
    local prefix = chance:prefix({ gender = "female" })
    assert(prefix ~= "Mr.", tip)
    prefix = chance:prefix({ gender = "male" })
    assert(prefix ~= "Mrs.", tip)
    assert(prefix ~= "Miss", tip)
end)

tip = 'prefix() can return a full prefix'
Helper.times_f(function()
    local prefix = chance:prefix({ full = true })
    assert(type(prefix) == "string", tip)
    assert(string.len(prefix) > 3, tip)
end)

tip = 'suffix() returns a random suffix'
Helper.times_f(function()
    local suffix = chance:suffix()
    assert(type(suffix) == "string", tip)
    assert(string.len(suffix) < 7, tip)
end)

tip = 'suffix() can return a full suffix'
Helper.times_f(function()
    local suffix = chance:suffix({ full = true })
    assert(type(suffix) == "string", tip)
    assert(string.len(suffix) > 5, tip)
end)

tip = 'nationality() returns a nationality that looks right'
Helper.times_f(function()
    local nationality = chance:nationality()
    assert(type(nationality) == "string", tip)
    local len = string.len(nationality)
    assert(len > 3 and len < 26, tip)
end)

tip = 'profession() returns a random profession'
Helper.times_f(function()
    local profession = chance:profession()
    assert(type(profession) == "string", tip)
    local len = string.len(profession)
    assert(len > 3, tip)
end)

tip = 'profession() returns a ranked profession'
Helper.times_f(function()
    local profession = chance:profession({ rank = true })
    assert(type(profession) == "string", tip)
    local profession_split = Helper.split(profession, " ")
    assert(#profession_split > 1, tip)
    assert(profession_split[1] == "Apprentice" or profession_split[1] == "Junior" or
            profession_split[1] == "Senior" or profession_split[1] == "Lead")
end)

tip = 'ssn() returns a random social security number'
Helper.times_f(function()
    local ssn = chance:ssn()
    assert(type(ssn) == "string", tip)
    assert(string.len(ssn) == 11, tip)
    assert(string.match(ssn, "^%d%d%d%-%d%d%-%d%d%d%d$") == ssn, tip)
end)

tip = 'ssn() can return just the last 4'
Helper.times_f(function()
    local ssn = chance:ssn({ ssn_four = true })
    assert(type(ssn) == "string", tip)
    assert(string.len(ssn) == 4, tip)
    assert(string.match(ssn, "^%d%d%d%d$") == ssn, tip)
end)

tip = 'aadhar() returns a random aadhar number with whitespace as separator'
Helper.times_f(function()
    local aadhar = chance:aadhar()
    assert(type(aadhar) == "string", tip)
    assert(string.len(aadhar) == 14, tip)
    assert(string.match(aadhar, "^%d%d%d%d%s%d%d%d%d%s%d%d%d%d$") == aadhar, tip)
end)

tip = 'aadhar() returns a random aadhar number with no separator'
Helper.times_f(function()
    local aadhar = chance:aadhar({ separated_by_whitespace = false })
    assert(type(aadhar) == "string", tip)
    assert(string.len(aadhar) == 12, tip)
    assert(string.match(aadhar, "^%d%d%d%d%d%d%d%d%d%d%d%d$") == aadhar, tip)
end)

tip = 'aadhar() can return just the last 4'
Helper.times_f(function()
    local aadhar = chance:aadhar({ only_last_four = true })
    assert(type(aadhar) == "string", tip)
    assert(string.len(aadhar) == 4, tip)
    assert(string.match(aadhar, "^%d%d%d%d$") == aadhar, tip)
end)

tip = 'mrz() should return a valid passport number'
local sample = "P<GBRFOLKS<<JOANNE<<<<<<<<<<<<<<<<<<<<<<<<<<2321126135GBR6902069F1601013<<<<<<<<<<<<<<02"
local mrz = chance:mrz({
    first =  'Joanne',
    last =  'Folks',
    gender = 'F',
    dob = '690206',
    expiry = '160101',
    passport_number = '232112613',
})
assert(sample == mrz, tip)

sample = "P<GBRKELLY<<LIDA<<<<<<<<<<<<<<<<<<<<<<<<<<<<3071365913GBR6606068F2003131<<<<<<<<<<<<<<04"
mrz = chance:mrz({
    first = 'Lida',
    last = 'Kelly',
    gender = 'F',
    dob = '660606',
    expiry = '200313',
    passport_number = '307136591',
})
assert(sample == mrz, tip)

tip = 'mrz() should return a valid random passport number when not given any inputs'
local mrz = chance:mrz()
assert(type(mrz) == "string", tip)
assert(string.sub(mrz, 1, 5) == "P<GBR", tip)
assert(string.len(mrz) == 88, tip)
local format = "^"
for i = 1, 9 do
    format = format .. "[%u%d<]"
end
format = format .. "%d%u%u%u"
for i = 1, 7 do
    format = format .. "%d"
end
format = format .. "%u"
for i = 1, 7 do
    format = format .. "%d"
end
for i = 1, 14 do
    format = format .. "[%u%d<]"
end
format = format .. "%d%d$"
assert(string.match(string.sub(mrz, 45), format) == string.sub(mrz, 45), tip)

print("-------->>>>>>>> person test ok <<<<<<<<--------", os.clock() - t1)

