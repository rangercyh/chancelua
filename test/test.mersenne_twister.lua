local Chance = require "chance"
local t1 = os.clock()
local chance = Chance.new()

local mt = chance:mersenne_twister(123)

assert(mt:genrand_int32() == 2991312382)
assert(mt:genrand_int31() == 1531059894)
assert(math.floor(mt:genrand_real1() * 1000000) == 286139)
assert(math.floor(mt:random() * 1000000) == 428470)
assert(math.floor(mt:genrand_real3() * 1000000) == 226851)
assert(math.floor(mt:genrand_res53() * 1000000) == 690884)

print("-------->>>>>>>> mersenne_twister test ok <<<<<<<<--------", os.clock() - t1)
