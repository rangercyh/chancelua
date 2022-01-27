local bits = require "utils.bit32"
local t1 = os.clock()
assert(bits.rshift(-100, 0) == -100 >> 0 & 0xffffffff)
assert(bits.rshift(113541447803251, 0) == 113541447803251 >> 0 & 0xffffffff)
assert(bits.lshift(-100, 1) == -100 << 1 & 0xffffffff)
assert(bits.bxor(-100, 1) == (-100 ~ 1) & 0xffffffff)
assert(bits.bxor(0, 3) == (0 ~ 3) & 0xffffffff)
assert(bits.bxor(-100, 3) == (-100 ~ 3) & 0xffffffff)
assert(bits.rshift(-99, 0) == (-99 >> 0) & 0xffffffff)

print("-------->>>>>>>> bit32 test ok <<<<<<<<--------", os.clock() - t1)
