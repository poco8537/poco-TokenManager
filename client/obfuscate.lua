function obfuscate(str, key)
    local hexParts = {}
    local keyLen = #key
    local sum = 0

    for i = 1, #str do
        local c = string.byte(str, i)
        local k = string.byte(key, ((i - 1) % keyLen) + 1)
        local x = (c + k) % 256
        sum = (sum + x) % 256
        hexParts[#hexParts + 1] = string.format('%02X', x)
    end

    local checksum = string.format('%02X', sum)
    return table.concat(hexParts) .. checksum
end
