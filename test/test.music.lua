local Helper = require "utils.helper"
local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

tip = 'note() returns a valid note'
Helper.times_f(function()
    local note = chance:note()
    assert(type(note) == "string", tip)
    assert(utf8.len(note) <= 2, tip)
end)

tip = 'midi_note() returns a valid midi note between 0 and 127'
Helper.times_f(function()
    local midi_note = chance:midi_note()
    assert(type(midi_note) == "number", tip)
    assert(midi_note >= 0 and midi_note <= 127, tip)
end)

tip = 'chord_quality() returns a valid chord quality'
Helper.times_f(function()
    local chord_quality = chance:chord_quality()
    assert(type(chord_quality) == "string", tip)
    assert(string.len(chord_quality) <= 4, tip)
end)

tip = 'chord() returns a valid chord'
Helper.times_f(function()
    local chord = chance:chord()
    assert(type(chord) == "string", tip)
    assert(utf8.len(chord) <= 6, tip)
end)

tip = 'tempo() returns a valid tempo between 40 and 320'
Helper.times_f(function()
    local tempo = chance:tempo()
    assert(type(tempo) == "number", tip)
    assert(tempo >= 40 and tempo <= 320, tip)
end)

print("-------->>>>>>>> music test ok <<<<<<<<--------", os.clock() - t1)
