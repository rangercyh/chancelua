local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

local tip = 'sentence() returns a random sentence'
Helper.times_f(function()
    local sentence = chance:sentence()
    assert(type(sentence) == "string", tip)
    local len = #Helper.split(sentence, " ")
    assert(len > 11 and len < 19, tip)
end)

tip = 'sentence() will obey bounds'
Helper.times_f(function()
    local sentence = chance:sentence({ words = 5 })
    assert(type(sentence) == "string", tip)
    local len = #Helper.split(sentence, " ")
    assert(len == 5, tip)
    assert(string.match(sentence, "[%u%l]+ [%u%l]+ [%u%l]+ [%u%l]+ [%u%l]+%.?") == sentence, tip)
end)

tip = 'syllable() returns a random syllable'
Helper.times_f(function()
    local syllable = chance:syllable()
    assert(type(syllable) == "string", tip)
    local len = string.len(syllable)
    assert(len > 1 and len < 4, tip)
end)

tip = 'syllable() obeys the capitalize option'
Helper.times_f(function()
    local syllable = chance:syllable({ capitalize = true })
    assert(type(syllable) == "string", tip)
    local len = string.len(syllable)
    assert(len > 1 and len < 4, tip)
    assert(string.find(syllable, "%u+"), tip)
end)

tip = 'word() returns a random word'
Helper.times_f(function()
    local word = chance:word()
    assert(type(word) == "string", tip)
    local len = string.len(word)
    assert(len > 1 and len < 10, tip)
end)

tip = 'word() obeys the capitalize option'
Helper.times_f(function()
    local word = chance:word({ capitalize = true })
    assert(type(word) == "string", tip)
    local len = string.len(word)
    assert(len > 1 and len < 10, tip)
    local c = string.sub(word, 1, 1)
    assert(string.upper(c) == c, tip)
end)

tip = 'word() can have a set number of syllables'
Helper.times_f(function()
    local word = chance:word({ syllables = 3 })
    assert(type(word) == "string", tip)
    local len = string.len(word)
    assert(len > 5 and len < 10, tip)
end)

tip = 'word() can have a set length'
Helper.times_f(function()
    local word = chance:word({ length = 5 })
    assert(type(word) == "string", tip)
    local len = string.len(word)
    assert(len == 5, tip)
end)

tip = 'word() throws if both syllables and length specified'
local fn = function()
    chance:word({ syllables = 3, length = 20 })
end
assert(not(pcall(fn)), tip)

tip = 'paragraph() returns a random paragraph'
Helper.times_f(function()
    local paragraph = chance:paragraph()
    assert(type(paragraph) == "string", tip)
    local len = #Helper.split(paragraph, "%.")
    assert(len > 2 and len < 9, tip)
end, 10)

tip = 'paragraph() will obey bounds'
Helper.times_f(function()
    local paragraph = chance:paragraph({ sentences = 5 })
    assert(type(paragraph) == "string", tip)
    local len = #Helper.split(paragraph, "%.")
    assert(len == 5, tip)
end, 10)

tip = 'paragraph() will obey line breaks'
Helper.times_f(function()
    local rand = math.random(1, 50)
    local paragraph = chance:paragraph({ sentences = rand, linebreak = true })
    assert(type(paragraph) == "string", tip)
    local len = #Helper.split(paragraph, "\n")
    assert(len == rand, tip)
end, 10)

print("-------->>>>>>>> text test ok <<<<<<<<--------", os.clock() - t1)
