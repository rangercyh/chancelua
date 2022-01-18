package.path = package.path .. ";../?.lua"

local Chance = require "chance"

local chance = Chance.new()

local mt = chance:mersenne_twister()

print(mt:genrand_int32())
print(mt:genrand_int31())
print(mt:genrand_real1())
print(mt:random())
print(mt:genrand_real3())
print(mt:genrand_res53())


