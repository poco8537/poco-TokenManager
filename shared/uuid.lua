function generate_uuid_v4()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    local uuid = string.gsub(template, '[xy]', function(c)
        local v
        if c == 'x' then
            v = math.random(0, 0xF)
        else
            v = math.random(8, 0xB)
        end
        return string.format('%x', v)
    end)
    return uuid
end
