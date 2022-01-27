local helper = require "utils.helper"

local mt = {}

function mt:paragraph(options)
    options = helper.init_options(options)
    local sentences = options.sentences or self:natural({ min = 3, max = 7 })
    local sentence_arr = self:n(self.sentence, self, sentences)
    local sep = options.linebreak and '\n' or ' '
    return table.concat(sentence_arr, sep)
end

-- Could get smarter about this than generating random words and
-- chaining them together. Such as: http://vq.io/1a5ceOh
function mt:sentence(options)
    options = helper.init_options(options)
    local words = options.words or self:natural({ min = 12, max = 18 })
    local punctuation = options.punctuation
    local word_arr = self:n(self.word, self, words)
    local text = table.concat(word_arr, " ")
    -- Capitalize first letter of sentence
    text = self:capitalize(text)
    -- Make sure punctuation has a usable value
    if punctuation ~= false then
        punctuation = punctuation or "."
        if string.match(punctuation, "^[%.%?!:;]$") ~= punctuation then
            punctuation = "."
        end
    end
    -- Add punctuation mark
    if punctuation then
        text = text .. punctuation
    end
    return text
end

function mt:syllable(options)
    options = helper.init_options(options)
    local length = options.length or self:natural({ min = 2, max = 3 })
    local consonants = "bcdfghjklmnprstvwz" -- consonants except hard to speak ones
    local vowels = "aeiou"  -- vowels
    local all = consonants .. vowels    -- all
    local text = ""
    local chr
    -- I'm sure there's a more elegant way to do this, but this works decently well.
    for i = 1, length do
        if i == 1 then
            -- First character can be anything
            chr = self:character({ pool = all })
        elseif not(string.find(consonants, chr)) then
            -- Last character was a vowel, now we want a consonant
            chr = self:character({ pool = consonants })
        else
            chr = self:character({ pool = vowels })
        end
        text = text .. chr
    end
    if options.capitalize then
        text = self:capitalize(text)
    end
    return text
end

function mt:word(options)
    options = helper.init_options(options)
    assert(not(options.syllables and options.length), "Chance: Cannot specify both syllables AND length.")

    local syllables = options.syllables or self:natural({ min = 1, max = 3 })
    local text = ""
    if options.length then
        -- Either bound word by length
        repeat
            text = text .. self:syllable()
        until string.len(text) >= options.length
        text = string.sub(text, 1, options.length)
    else
        -- Or by number of syllables
        for _ = 1, syllables do
            text = text .. self:syllable()
        end
    end
    if options.capitalize then
        text = self:capitalize(text)
    end
    return text
end

return mt
