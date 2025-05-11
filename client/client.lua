local TokenManager = {}
_G.TokenManager = TokenManager
local pendingRequests = {}

function TokenManager.GetToken(callback)
    local requestId = tostring(callback)
    pendingRequests[requestId] = callback
    TriggerServerEvent(GetCurrentResourceName() .. ":poco:TokenManager:request", requestId)
end

RegisterNetEvent(GetCurrentResourceName() .. ":poco:TokenManager:response", function(requestId, token)
    local callback = pendingRequests[requestId]
    if not callback then
        return
    end

    pendingRequests[requestId] = nil
    callback(token)
end)
