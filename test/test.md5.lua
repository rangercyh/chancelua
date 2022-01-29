local Chance = require "chance"
local MD5 = require "utils.md5"
local t1 = os.clock()
local a = MD5.sum("asdf")
assert(MD5.tohex(a) == "912ec803b2ce49e4a541068d495ab570")
assert(MD5.sumhexa("asdf") == "912ec803b2ce49e4a541068d495ab570")
assert(MD5.sumhexa("") == "d41d8cd98f00b204e9800998ecf8427e")
assert(MD5.sumhexa("A") == "7fc56270e7a70fa81a5935b72eacbe29")
assert(MD5.sumhexa("abcdefghijklmnop") == "1d64dce239c4437b7736041db089e1b9")
assert(MD5.sumhexa("0") == "cfcd208495d565ef66e7dff9f98764da")
assert(MD5.sumhexa("0000") == "4a7d1ed414474e4033ac29ccb8653d9b")
assert(MD5.sumhexa(string.char(97, 98, 99)) == "900150983cd24fb0d6963f7d28e17f72")
assert(MD5.sumhexa(string.char(0,1,2,3,97,98,99)) == "cd51793a3fddc3031543a35e9d4db296")
assert(MD5.sumhexa("asdfasdfasdfasdf") == "08afd6f9ae0c6017d105b4ce580de885")

local chance = Chance.new()

local g = chance.md5()
assert(g:update("asdf"):finish() == a)

print("-------->>>>>>>> md5 test ok <<<<<<<<--------", os.clock() - t1)
