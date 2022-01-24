local helper = require "utils.helper"

local mt = {}

function mt:address()
end
function mt:altitude()
end
function mt:areacode()
end
function mt:city()
end
function mt:coordinates()
end
function mt:countries()
end
function mt:country()
end
function mt:depth()
end
function mt:geohash()
end
function mt:geojson()
end
function mt:latitude()
end
function mt:longitude()
end
function mt:phone()
end
function mt:postal()
end
function mt:postcode()
end
function mt:counties()
end
function mt:county()
end
function mt:provinces(options)
    options = helper.init_options(options, { country = "ca" })
    return self:get("provinces")[string.lower(options.country)]
end
function mt:province()
end
function mt:state()
end
function mt:states()
end
function mt:street()
end
function mt:street_suffix()
end
function mt:street_suffixes()
end
-- Note: only returning US zip codes, internationalization will be a whole
-- other beast to tackle at some point.
function mt:zip()
end

return mt
