local TokenManager = {}
_G.TokenManager = TokenManager
local pendingTokenRequests = {}

function TokenManager.GetEvent(eventName, callback)
    local requestId = generate_uuid_v4()
    pendingTokenRequests[requestId] = {
        callback = callback,
        eventName = eventName
    }
    TriggerServerEvent(GetCurrentResourceName() .. ':poco:TokenManager:request', requestId)
end

RegisterNetEvent(GetCurrentResourceName() .. ':poco:TokenManager:response', function(requestId, token)
    local requestInfo = pendingTokenRequests[requestId]
    if not requestInfo then
        return
    end

    local function emitValidatedEvent(...)
        local args = {...}
        local text = json.encode(args)
        local encrypted = obfuscate(text, token)
        TriggerServerEvent(requestInfo.eventName, token, encrypted)
    end

    pendingTokenRequests[requestId] = nil
    requestInfo.callback(emitValidatedEvent)
end)
