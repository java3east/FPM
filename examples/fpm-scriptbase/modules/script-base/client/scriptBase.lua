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
    if not callbackEvents[name] then
        print("^1 ERROR: unregistered callback '" .. tostring(name) .. "'.^7")
        TriggerServerEvent('fpm:script-base:event:callback@' .. GetCurrentResourceName(), cid)
        return
    end
    TriggerServerEvent('fpm:script-base:event:callback@' .. GetCurrentResourceName() , cid, callbackEvents[name](...))
end)



local callbacks = {}
local callbackId = 1

RegisterNetEvent('fpm:script-base:event:callback@' .. GetCurrentResourceName(), function(id, ...)
    callbacks[id](...)
end)

---Creates a new callback Action.
---@param name string the name of the callback.
---@param ... any the callback data.
---@return Action action the callback action.
function ScriptBase.callback(name, ...)
    return Action:constructor(function(cb, name, ...)
        -- register callback function
        callbacks[callbackId] = cb

        -- trigger event
        TriggerServerEvent('fpm:script-base:event:triggerCallback@' .. GetCurrentResourceName(), callbackId, name, ...)

        -- increment callback id
        callbackId = callbackId + 1
    end, name, ...)
end