-- BlueImp MD5 hashing algorithm from https://github.com/blueimp/JavaScript-MD5
local BlueImpMD5 = {
    VERSION = '1.0.1'
}
--[[
Add integers, wrapping at 2^32. This uses 16-bit operations internally
to work around bugs in some JS interpreters.
]]
function BlueImpMD5.safe_add()
end
-- Bitwise rotate a 32-bit number to the left.
function BlueImpMD5.bit_roll()
end
-- These functions implement the five basic operations the algorithm uses.
function BlueImpMD5.md5_cmn()
end
function BlueImpMD5.md5_ff()
end
function BlueImpMD5.md5_gg()
end
function BlueImpMD5.md5_hh()
end
function BlueImpMD5.md5_ii()
end
-- Calculate the MD5 of an array of little-endian words, and a bit length.
function BlueImpMD5.binl_md5()
end
-- Convert an array of little-endian words to a string
function BlueImpMD5.binl2rstr()
end
--[[
Convert a raw string to an array of little-endian words
Characters >255 have their high-byte silently ignored.
]]
function BlueImpMD5.rstr2binl()
end
-- Calculate the MD5 of a raw string
function BlueImpMD5.rstr_md5()
end
-- Calculate the HMAC-MD5, of a key and some data (raw strings)
function BlueImpMD5.rstr_hmac_md5()
end
-- Convert a raw string to a hex string
function BlueImpMD5.rstr2hex()
end
-- Encode a string as utf-8
function BlueImpMD5.str2rstr_utf8()
end
-- Take string arguments and return either raw or hex encoded strings
function BlueImpMD5.raw_md5()
end
function BlueImpMD5.hex_md5()
end
function BlueImpMD5.raw_hmac_md5()
end
function BlueImpMD5.hex_hmac_md5()
end
function BlueImpMD5.md5()
end

return BlueImpMD5
