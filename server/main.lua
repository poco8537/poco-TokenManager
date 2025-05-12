local TokenManager = {}
_G.TokenManager = TokenManager
local playerTokens = {}

-- Token validity period in seconds
local TOKEN_TTL = 10

function TokenManager.Generate(player_id)
    if not DoesPlayerExist(player_id) then
        return false
    end

    if not playerTokens[player_id] then
        playerTokens[player_id] = {}
    end

    local token = generate_uuid_v4()
    playerTokens[player_id][token] = {
        created = os.time()
    }

    return token
end

function TokenManager.VerifyAndExpire(player_id, token)
    if not playerTokens[player_id] then
        return false
    end

    local tokenInfo = playerTokens[player_id][token]
    if not tokenInfo then
        return false
    end

    playerTokens[player_id][token] = nil
    if next(playerTokens[player_id]) == nil then
      playerTokens[player_id] = nil
    end

    if os.time() - tokenInfo.created > TOKEN_TTL then
        return false
    end

    return true
end

function TokenManager.wrapWithTokenValidation(func)
    return function(token, encryptedPayload)
        local source = source

        if not TokenManager.VerifyAndExpire(source, token) then
            return
        end

        local decryptedJson = deobfuscate(encryptedPayload, token)
        if not decryptedJson then
            return
        end

        local decodedArgs = json.decode(decryptedJson)
        func(table.unpack(decodedArgs))
    end
end

RegisterNetEvent(GetCurrentResourceName() .. ':poco:TokenManager:request', function(requestId)
    local source = source
    local token = TokenManager.Generate(source)
    if token then
        TriggerClientEvent(GetCurrentResourceName() .. ':poco:TokenManager:response', source, requestId, token)
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    playerTokens[source] = nil
end)
