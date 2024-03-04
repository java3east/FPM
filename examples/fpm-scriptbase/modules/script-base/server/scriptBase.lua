---@diagnostic disable: duplicate-set-field
---@author Java3east [Discord: java3east]

local callbackEvents = {}

---Registers a new callback.
---@param name string the name of the callback.
---@param func function the callback function.
function ScriptBase.registerCallback(name, func)
    callbackEvents[name] = func
end

RegisterNetEvent('fpm:script-base:event:triggerCallback@' .. GetCurrentResourceName(), function(cid, name, ...)
    local src = source
    if not callbackEvents[name] then
        print("^1 ERROR: unregistered callback '" .. tostring(name) .. "'.^7")
        TriggerClientEvent('fpm:script-base:event:callback@' .. GetCurrentResourceName(), src, cid)
        return
    end
    TriggerClientEvent('fpm:script-base:event:callback@' .. GetCurrentResourceName() , src, cid, callbackEvents[name](src, ...))
end)



local callbacks = {}
local callbackId = 1

RegisterNetEvent('fpm:script-base:event:callback@' .. GetCurrentResourceName(), function(id, ...)
    local src = source
    callbacks[id](src, ...)
end)

---Creates a new callback Action.
---@param name string the name of the callback.
---@param ... any the callback data.
---@return Action action the callback action.
function ScriptBase.callback(player, name, ...)
    return Action:constructor(function(cb, player, name, ...)
        -- register callback function
        callbacks[callbackId] = cb

        -- trigger event
        TriggerClientEvent('fpm:script-base:event:triggerCallback@' .. GetCurrentResourceName(), player, callbackId, name, ...)

        -- increment callback id
        callbackId = callbackId + 1
    end, player, name, ...)
end