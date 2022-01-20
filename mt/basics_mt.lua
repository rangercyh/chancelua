local mt = {}

--[[
Return a random bool, either true or false

@param {Object} [options={ likelihood: 50 }] alter the likelihood of receiving a true or false value back.
@throws {RangeError} if the likelihood is out of bounds
@returns {Bool} either true or false
]]
function mt:bool()
     return self:random()
end
function mt:falsy()
end
function mt:animal()
end
--[[
     *  Return a random character.
     *
     *  @param {Object} [options={}] can specify a character pool or alpha,
     *    numeric, symbols and casing (lower or upper)
     *  @returns {String} a single random character
]]
function mt:character()
end
-- Note, wanted to use "float" or "double" but those are both JS reserved words.

-- Note, fixed means N OR LESS digits after the decimal. This because
-- It could be 14.9000 but in JavaScript, when this is cast as a number,
-- the trailing zeroes are dropped. Left to the consumer if trailing zeroes are
-- needed
--[[
*  Return a random floating point number
     *
     *  @param {Object} [options={}] can specify a fixed precision, min, max
     *  @returns {Number} a single floating point number
     *  @throws {RangeError} Can only specify fixed or precision, not both. Also
     *    min cannot be greater than max
]]
function mt:floating()
end
--[[
*  Return a random integer
     *
     *  NOTE the max and min are INCLUDED in the range. So:
     *  chance.integer({min: 1, max: 3});
     *  would return either 1, 2, or 3.
     *
     *  @param {Object} [options={}] can specify a min and/or max
     *  @returns {Number} a single random integer number
     *  @throws {RangeError} min cannot be greater than max
]]
function mt:integer()
end
--[[
*  Return a random natural
     *
     *  NOTE the max and min are INCLUDED in the range. So:
     *  chance.natural({min: 1, max: 3});
     *  would return either 1, 2, or 3.
     *
     *  @param {Object} [options={}] can specify a min and/or max or a numerals count.
     *  @returns {Number} a single random integer number
     *  @throws {RangeError} min cannot be greater than max
]]
function mt:natural()
end
--[[
*  Return a random prime number
     *
     *  NOTE the max and min are INCLUDED in the range.
     *
     *  @param {Object} [options={}] can specify a min and/or max
     *  @returns {Number} a single random prime number
     *  @throws {RangeError} min cannot be greater than max nor negative
]]
function mt:prime()
end
--[[
Determine whether a given number is prime or not.
]]
function mt:is_prime()
end
--[[
*  Return a random hex number as string
     *
     *  NOTE the max and min are INCLUDED in the range. So:
     *  chance.hex({min: '9', max: 'B'});
     *  would return either '9', 'A' or 'B'.
     *
     *  @param {Object} [options={}] can specify a min and/or max and/or casing
     *  @returns {String} a single random string hex number
     *  @throws {RangeError} min cannot be greater than max
]]
function mt:hex()
end
function mt:letter()
end
--[[
*  Return a random string
     *
     *  @param {Object} [options={}] can specify a length or min and max
     *  @returns {String} a string of random length
     *  @throws {RangeError} length cannot be less than zero
]]
function mt:string()
end

--[[
*  Return a random string matching the given template.
     *
     *  The template consists of any number of "character replacement" and
     *  "character literal" sequences. A "character replacement" sequence
     *  starts with a left brace, has any number of special replacement
     *  characters, and ends with a right brace. A character literal can be any
     *  character except a brace or a backslash. A literal brace or backslash
     *  character can be included in the output by escaping with a backslash.
     *
     *  The following replacement characters can be used in a replacement
     *  sequence:
     *
     *      "#": a random digit
     *      "a": a random lower case letter
     *      "A": a random upper case letter
     *
     *  Example: chance.template('{AA###}-{##}')
     *
     *  @param {String} template string.
     *  @returns {String} a random string matching the template.
]]
function mt:template()
end
--[[
*  Return a random buffer
     *
     *  @param {Object} [options={}] can specify a length
     *  @returns {Buffer} a buffer of random length
     *  @throws {RangeError} length cannot be less than zero
]]
function mt:buffer()
end

return mt
