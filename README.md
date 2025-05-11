## As far as I know, the cheater cannot add event handlers using a Lua injector. This script was written on that assumption, so if the above explanation is wrong, the this script is useless.

## TokenManager

`TokenManager` is a FiveM script that adds **token-based authentication** to server events, cheater from calling protected handlers. Since cheaters can’t generate valid tokens on their own, your server-side logic remains secure.

---

### Installation

1. Download poco-TokenManager from [https://github.com/poco8537/poco-TokenManager/releases](https://github.com/poco8537/poco-TokenManager/releases).
2. Extract it into the `resources/` folder.
3. In `server.cfg`, enable the resource:

   ```cfg
   ensure poco-TokenManager
   ```

   or

   ```cfg
   start poco-TokenManager
   ```

---

### Usage

1. **Load the Scripts**
   In the `fxmanifest.lua` of the resource you want to protect, add:

   ```lua
   client_script "@poco-TokenManager/client/client.lua"
   server_script "@poco-TokenManager/server/server.lua"
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
   TokenManager.GetToken(function(token)
       TriggerServerEvent("chat", token, "Hello!")
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
   TokenManager.GetToken(function(token)
      TriggerServerEvent("chat", token, "Hello!")
   end)
end)
```
