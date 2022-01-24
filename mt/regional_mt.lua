local helper = require "utils.helper"

local mt = {}

function mt:it_vat()
    local it_vat = self:natural({ min = 1, max = 1800000 })
    it_vat = self:pad(it_vat, 7) .. self:pad(self:pick(self:provinces({ country = "it" })).code, 3)
    return it_vat .. self:luhn_calculate(it_vat)
end

--[[
this generator is written following the official algorithm
all data can be passed explicitely or randomized by calling chance.cf() without options
the code does not check that the input data is valid (it goes beyond the scope of the generator)

@param  [Object] options = { first: first name,
                             last: last name,
                             gender: female|male,
                             birthday: JavaScript date object,
                             city: string(4), 1 letter + 3 numbers
                            }
@return [string] codice fiscale
]]
function mt:cf()
end
function mt:pl_pesel()
end
function mt:pl_nip()
end
function mt:pl_regon()
end

return mt
