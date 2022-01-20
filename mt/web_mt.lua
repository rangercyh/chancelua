local mt = {}

function mt:avatar()
end
--[[
#Description:
===============================================
Generate random color value base on color type:
-> hex
-> rgb
-> rgba
-> 0x
-> named color
#Examples:
===============================================
* Geerate random hex color
chance.color() => '#79c157' / 'rgb(110,52,164)' / '0x67ae0b' / '#e2e2e2' / '#29CFA7'
* Generate Hex based color value
chance.color({format: 'hex'})    => '#d67118'
* Generate simple rgb value
chance.color({format: 'rgb'})    => 'rgb(110,52,164)'
* Generate Ox based color value
chance.color({format: '0x'})     => '0x67ae0b'
* Generate graiscale based value
chance.color({grayscale: true})  => '#e2e2e2'
* Return valide color name
chance.color({format: 'name'})   => 'red'
* Make color uppercase
chance.color({casing: 'upper'})  => '#29CFA7'
* Min Max values for RGBA
var light_red = chance.color({format: 'hex', min_red: 200, max_red: 255, max_green: 0,
    max_blue: 0, min_alpha: .2, max_alpha: .3});
@param  [object] options
@return [string] color value
]]
function mt:color()
end
function mt:domain()
end
function mt:email()
end
--[[
#Description:
===============================================
Generate a random Facebook id, aka fbid.
NOTE: At the moment (Sep 2017), Facebook ids are
"numeric strings" of length 16.
However, Facebook Graph API documentation states that
"it is extremely likely to change over time".
@see https://developers.facebook.com/docs/graph-api/overview/
#Examples:
===============================================
chance.fbid() => '1000035231661304'
@return [string] facebook id
]]
function mt:fbid()
end
function mt:google_analytics()
end
function mt:hashtag()
end
function mt:ip()
end
function mt:ipv6()
end
function mt:klout()
end
function mt:mac()
end
function mt:semver()
end
function mt:tlds()
end
function mt:tld()
end
function mt:twitter()
end
function mt:url()
end
function mt:port()
end
function mt:locale()
end
function mt:locales()
end
function mt:loremPicsum()
end

return mt
