-- BlueImp MD5 hashing algorithm from https://github.com/blueimp/JavaScript-MD5

local mt = {}
mt.__index = mt

--[[
Add integers, wrapping at 2^32. This uses 16-bit operations internally
to work around bugs in some JS interpreters.
]]
function mt:safe_add()
end
-- Bitwise rotate a 32-bit number to the left.
function mt:bit_roll()
end
-- These functions implement the five basic operations the algorithm uses.
function mt:md5_cmn()
end
function mt:md5_ff()
end
function mt:md5_gg()
end
function mt:md5_hh()
end
function mt:md5_ii()
end
-- Calculate the MD5 of an array of little-endian words, and a bit length.
function mt:binl_md5()
end
-- Convert an array of little-endian words to a string
function mt:binl2rstr()
end
--[[
Convert a raw string to an array of little-endian words
Characters >255 have their high-byte silently ignored.
]]
function mt:rstr2binl()
end
-- Calculate the MD5 of a raw string
function mt:rstr_md5()
end
-- Calculate the HMAC-MD5, of a key and some data (raw strings)
function mt:rstr_hmac_md5()
end
-- Convert a raw string to a hex string
function mt:rstr2hex()
end
-- Encode a string as utf-8
function mt:str2rstr_utf8()
end
-- Take string arguments and return either raw or hex encoded strings
function mt:raw_md5()
end
function mt:hex_md5()
end
function mt:raw_hmac_md5()
end
function mt:hex_hmac_md5()
end
function mt:md5()
end

local _VERSION = '1.0.1'
local M = {}
function M.new()

end
return M
