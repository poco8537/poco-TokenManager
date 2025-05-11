local TokenManager = {}
_G.TokenManager = TokenManager
local tokens = {}

function TokenManager.Generate(player_id)
    if not DoesPlayerExist(player_id) then
        return false
    end

    if not tokens[player_id] then
        tokens[player_id] = {}
    end

    local token = math.random(111111111, 9999999999)
    tokens[player_id][token] = true

    return token
end

function TokenManager.VerifyAndExpire(player_id, token)
    if not tokens[player_id] then
        return false
    end

    if not tokens[player_id][token] then
        return false
    end

    tokens[player_id] = nil

    return true
end

function TokenManager.wrapWithTokenValidation(func)
    return function(token, ...)
        local source = source

        if not TokenManager.VerifyAndExpire(source, token) then
            return
        end

        func(...)
    end
end

RegisterNetEvent(GetCurrentResourceName() .. ":poco:TokenManager:request", function(requestId)
    local source = source
    local token = TokenManager.Generate(source)
    if token then
        TriggerClientEvent(GetCurrentResourceName() .. ":poco:TokenManager:response", source, requestId, token)
    end
end)

AddEventHandler("playerDropped", function()
    local source = source
    tokens[source] = nil
end)
