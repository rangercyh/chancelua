local base64 = require "utils.base64"

local mt = {}

-- Android GCM Registration ID
function mt:android_id()
    return "APA91" .. self:string({
        pool = "0123456789abcefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-_",
        length = 178,
    })
end

-- Apple Push Token
function mt:apple_token()
    return self:string({ pool = "abcdef1234567890", length = 64, })
end

-- Windows Phone 8 ANID2
function mt:wp8_anid2()
    return base64(self:hash({ length = 32 }))
end

-- Windows Phone 7 ANID
function mt:wp7_anid()
    return "A=" .. string.upper(string.gsub(self:guid(), '%-', "")) .. "&E=" ..
        self:hash({ length = 3 }) .. "&W=" .. self:integer({ min = 0, max = 9 })
end

-- BlackBerry Device PIN
function mt:bb_pin()
    return self:hash({ length = 8 })
end

return mt
