## This approach is a mitigation tool rather than a complete solution.

## TokenManager

`TokenManager` is a FiveM script that adds **data encryption** and **token-based authentication** to server events, preventing cheaters from invoking protected handlers.


---

### Installation

1. Download poco-TokenManager from [https://github.com/poco8537/poco-TokenManager/releases](https://github.com/poco8537/poco-TokenManager/releases).
2. Extract it into the `resources/` folder.
3. In `server.cfg`, enable the resource:

   ```cfg
   ensure poco-TokenManager
   ```

---

### Usage

1. **Load the Scripts**
   In the `fxmanifest.lua` of the resource you want to protect, add:

   ```lua
   client_scripts {
       "@poco-TokenManager/client/obfuscate.lua",
       "@poco-TokenManager/client/main.lua",
   }
   server_scripts {
       "@poco-TokenManager/server/obfuscate.lua",
       "@poco-TokenManager/server/main.lua",
   }
   shared_script "@poco-TokenManager/shared/uuid.lua"
   ```

2. **Server Events**
   In your server-side Lua, register events with `TokenManager.wrapWithTokenValidation`:
   
   ```lua
   RegisterNetEvent("chat", TokenManager.wrapWithTokenValidation(function(msssage)
      local src = source
      TriggerClientEvent("chatMessage", -1, {255, 255, 255}, msssage)
   end))
   ```

3. **Request Token from Client Before Triggering**
   Replace direct `TriggerServerEvent` calls in your client scripts with:
   
   ```lua
   TokenManager.GetEvent("chat"--[[EventName]], function(emitValidatedEvent)
      emitValidatedEvent("Hello!")
   end)
   ```

---

### Example

```lua
-- server.lua
RegisterNetEvent("chat", TokenManager.wrapWithTokenValidation(function(msssage)
    TriggerClientEvent("chatMessage", -1, {255, 255, 255}, msssage)
end))

-- client.lua
RegisterCommand("newchat", function()
   TokenManager.GetEvent("chat"--[[EventName]], function(emitValidatedEvent)
      emitValidatedEvent("Hello!")
   end)
end)
```
