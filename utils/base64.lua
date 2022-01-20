local byte, rep = string.byte, string.rep
local bs = { [0] =
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/',
}
return function(s)
    local pad = 2 - ((#s - 1) % 3)
    s = (s .. rep('\0', pad)):gsub("...", function(cs)
        local a, b, c = byte(cs, 1, 3)
        return bs[a >> 2] .. bs[(a & 3) << 4 | b >> 4] .. bs[(b & 15) << 2 | c >> 6] .. bs[c & 63]
    end)
    return s:sub(1, #s - pad) .. rep('=', pad)
end
