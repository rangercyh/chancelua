local helper = require "utils.helper"

local mt = {}

local scales = {
    naturals = { 'C', 'D', 'E', 'F', 'G', 'A', 'B' },
    flats = { 'D♭', 'E♭', 'G♭', 'A♭', 'B♭' },
    sharps = { 'C♯', 'D♯', 'F♯', 'G♯', 'A♯' },
}
scales.all = {}
scales.flatKey = {}
scales.sharpKey = {}
for _, v in pairs(scales.naturals) do
    table.insert(scales.all, v)
    table.insert(scales.flatKey, v)
    table.insert(scales.sharpKey, v)
end
for _, v in ipairs(scales.flats) do
    table.insert(scales.all, v)
    table.insert(scales.flatKey, v)
end
for _, v in ipairs(scales.sharps) do
    table.insert(scales.all, v)
    table.insert(scales.sharpKey, v)
end
function mt:note(options)
    -- choices for 'notes' option:
    -- flatKey - chromatic scale with flat notes (default)
    -- sharpKey - chromatic scale with sharp notes
    -- flats - just flat notes
    -- sharps - just sharp notes
    -- naturals - just natural notes
    -- all - naturals, sharps and flats
    options = helper.init_options(options, { notes = "flatKey" })
    return self:pickone(scales[options.notes])
end

function mt:midi_note(options)
    local min, max = 0, 127
    options = helper.init_options(options, { min = min, max = max })
    return self:integer({ min = options.min, max = options.max })
end

function mt:chord_quality(options)
    options = helper.init_options(options, { jazz = true })
    local chord_qualities = { "maj", "min", "aug", "dim" }
    if options.jazz then
        chord_qualities = {
            "maj7",
            "min7",
            "7",
            "sus",
            "dim",
            "ø"
        }
    end
    return self:pickone(chord_qualities)
end

function mt:chord(options)
    options = helper.init_options(options)
    return self:note(options) .. self:chord_quality(options)
end

function mt:tempo(options)
    local min, max = 40, 320
    options = helper.init_options(options, { min = min, max = max })
    return self:integer({ min = options.min, max = options.max })
end

return mt
