-- Mersenne Twister from https://gist.github.com/banksean/300494
--[[
A C-program for MT19937, with initialization improved 2002/1/26.
Coded by Takuji Nishimura and Makoto Matsumoto.

Before using, initialize the state by using init_genrand(seed)
or init_by_array(init_key, key_length).

Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

3. The names of its contributors may not be used to endorse or promote
products derived from this software without specific prior written
permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


Any feedback is very welcome.
http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
email: m-mat @ math.sci.hiroshima-u.ac.jp (remove space)
]]

local bits = require "utils.bit32"

-- Period parameters
local N = 624
local M = 397
local MATRIX_A = 0x9908b0df         -- constant vector a
local UPPER_MASK = 0x80000000       -- most significant w-r bits
local LOWER_MASK = 0x7fffffff       -- least significant r bits
local LEFT_MASK = 0xffff0000
local RIGHT_MASK = 0x0000ffff

local mt = {}
mt.__index = mt

-- initializes mt[N] with a seed
function mt:init_genrand(s)
    self.mt[0] = bits.rshift(s, 0)
    for i = 1, N - 1 do
        s = bits.bxor(self.mt[i - 1], bits.rshift(self.mt[i - 1], 30))
        self.mt[i] = bits.lshift(bits.rshift(bits.band(s, LEFT_MASK), 16) * 1812433253, 16) +
                bits.band(s, RIGHT_MASK) * 1812433253 + i
        --[[
        See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier.
        In the previous versions, MSBs of the seed affect
        only MSBs of the array mt[].
        2002/01/09 modified by Makoto Matsumoto
        ]]
        self.mt[i] = bits.rshift(self.mt[i], 0)
        -- for >32 bit machines
    end
    self.mti = N
end

--[[
initialize by an array with array-length
init_key is the array for initializing keys
key_length is its length
slight change for C++, 2004/2/26
]]
function mt:init_by_array(init_key, key_length)
    local i, j, k, s = 1, 0
    self:init_genrand(19650218)
    k = N > key_length and N or key_length
    for _ = k, 1, -1 do
        s = bits.bxor(self.mt[i - 1], bits.rshift(self.mt[i - 1], 30))
        self.mt[i] = bits.bxor(self.mt[i],
                bits.lshift(bits.rshift(bits.band(s, LEFT_MASK), 16) * 1664525, 16) +
                bits.band(s, RIGHT_MASK) * 1664525) + init_key[j] + j  -- non linear
        self.mt[i] = bits.rshift(self.mt[i], 0) -- for WORDSIZE > 32 machines
        i = i + 1
        j = j + 1
        if i >= N then
            self.mt[0] = self.mt[N - 1]
            i = 1
        end
        if j >= key_length then
            j = 0
        end
    end
    for _ = N - 1, 1, -1 do
        s = bits.bxor(self.mt[i - 1], bits.rshift(self.mt[i - 1], 30))
        self.mt[i] = bits.bxor(self.mt[i],
                bits.lshift(bits.rshift(bits.band(s, LEFT_MASK), 16) * 1566083941, 16) +
                bits.band(s, RIGHT_MASK) * 1566083941) - i    -- non linear
        self.mt[i] = bits.rshift(self.mt[i], 0) -- for WORDSIZE > 32 machines
        i = i + 1
        if i >= N then
            self.mt[0] = self.mt[N - 1]
            i = 1
        end
    end
    self.mt[0] = 0x80000000     -- MSB is 1; assuring non-zero initial array
end

-- generates a random number on [0,0xffffffff]-interval
function mt:genrand_int32()
    -- mag01[x] = x * MATRIX_A  for x=0,1
    local mag01, y = {
        [0] = 0x0,
        [1] = MATRIX_A,
    }
    if self.mti >= N then   -- generate N words at one time
        if self.mti == N + 1 then   -- if init_genrand() has not been called,
            self:init_genrand(5489) -- a default initial seed is used
        end
        for kk = 0, N - M - 1 do
            y = bits.bor(bits.band(self.mt[kk], UPPER_MASK), bits.band(self.mt[kk + 1], LOWER_MASK))
            self.mt[kk] = bits.bxor(bits.bxor(self.mt[kk + M], bits.rshift(y, 1)), mag01[bits.band(y, 0x1)])
        end
        for kk = N - M, N - 2 do
            y = bits.bor(bits.band(self.mt[kk], UPPER_MASK), bits.band(self.mt[kk + 1], LOWER_MASK))
            self.mt[kk] = bits.bxor(bits.bxor(self.mt[kk + (M - N)], bits.rshift(y, 1)), mag01[bits.band(y, 0x1)])
        end
        y = bits.bor(bits.band(self.mt[N - 1], UPPER_MASK), bits.band(self.mt[0], LOWER_MASK))
        self.mt[N - 1] = bits.bxor(bits.bxor(self.mt[M - 1], bits.rshift(y, 1)), mag01[bits.band(y, 0x1)])

        self.mti = 0
    end

    y = self.mt[self.mti]
    self.mti = self.mti + 1

    -- Tempering
    y = bits.bxor(y, bits.rshift(y, 11))
    y = bits.bxor(y, bits.band(bits.lshift(y, 7), 0x9d2c5680))
    y = bits.bxor(y, bits.band(bits.lshift(y, 15), 0xefc60000))
    y = bits.bxor(y, bits.rshift(y, 18))

    return bits.rshift(y, 0)
end

-- generates a random number on [0,0x7fffffff]-interval
function mt:genrand_int31()
    return bits.rshift(self:genrand_int32(), 1)
end

-- generates a random number on [0,1]-real-interval
function mt:genrand_real1()
    return self:genrand_int32() * (1.0 / 4294967295.0)
    -- divided by 2^32-1
end

-- generates a random number on [0,1)-real-interval
function mt:random()
    return self:genrand_int32() * (1.0 / 4294967296.0)
    -- divided by 2^32
end

-- generates a random number on (0,1)-real-interval
function mt:genrand_real3()
    return (self:genrand_int32() + 0.5) * (1.0 / 4294967296.0)
    -- divided by 2^32
end

-- generates a random number on [0,1) with 53-bit resolution
function mt:genrand_res53()
    local a = bits.rshift(self:genrand_int32(), 5)
    local b = bits.rshift(self:genrand_int32(), 6)
    return (a * 67108864.0 + b) * (1.0 / 9007199254740992.0)
end

local MersenneTwister = {}
function MersenneTwister.new(seed)
    if not seed then
        -- kept random number same size as time used previously to ensure no unexpected results downstream
        seed = math.floor(math.random() * 10^13)
    end
    local self = setmetatable({
        mt = {},        -- the array for the state vector
        mti = N + 1,    -- mti==N + 1 means mt[N] is not initialized
    }, mt)
    self:init_genrand(seed)
    return self
end
return MersenneTwister
