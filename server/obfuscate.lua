function verifyIntegrity(hexWithChecksum)
    if #hexWithChecksum < 4 then
        return false
    end
    local dataHex = hexWithChecksum:sub(1, -3)
    local provided = hexWithChecksum:sub(-2)
    if #dataHex % 2 ~= 0 then
        return false
    end
    local sum = 0
    for i = 1, #dataHex, 2 do
        local part = dataHex:sub(i, i + 1)
        local byte = tonumber(part, 16)
        if not byte then
            return false
        end
        sum = (sum + byte) % 256
    end
    local expected = string.format('%02X', sum)
    return provided == expected
end

function deobfuscate(hexWithChecksum, key)
    if not verifyIntegrity(hexWithChecksum) then
        return
    end

    local hexstr = hexWithChecksum:sub(1, -3)
    local keyLen = #key
    local chars = {}

    for i = 1, #hexstr, 2 do
        local part = hexstr:sub(i, i + 1)
        local byte = tonumber(part, 16)
        if not byte then
            return nil
        end
        local idx = ((i - 1) / 2) % keyLen + 1
        local k = string.byte(key, idx)
        local c = (byte - k) % 256
        chars[#chars + 1] = string.char(c)
    end
    return table.concat(chars)
end
