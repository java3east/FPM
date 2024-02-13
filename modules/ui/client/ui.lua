---This represents a 'INTERFACE'. It is not supposed to, but can be, used as class.
---@class IUI : CLASS
IUI = CLASS:new('IUI')
IUI.__index = IUI

---Register a new NUI callback. This will call the provided function, and the return value, will be given back to the UI.
---@param name string the name of the callback.
---@param func function the function to call, when the callback gets triggered.
function IUI.on(name, func)
    RegisterNUICallback(name, function(data, cb)
        -- get result
        local result = func(data)

        -- response data
        local callbackData = { code = 200, data = result }

        -- debug
        debug('calling back: ' .. json.encode(callbackData))

        -- callback
        cb(callbackData)
    end)
end

---Send a message to the UI.
---@param name string the name of the message.
---@param data table the data of this message.
function IUI.send(name, data)
    -- the message table
    local message = { name = name, data = data }

    -- debug
    debug('sending: ' .. json.encode(message))

    -- send the message to the UI
    SendNUIMessage(message)
end

function IUI:new() end