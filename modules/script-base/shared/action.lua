---@author Java3east [Discord: java3east]

---@class Action : CLASS
---@field private __func function
---@field private __arguments Array<any>
Action = class('Action')

---Creates a new action and returns it.
---@param func function the action function.
---@return Action action the created action object.
function Action:constructor(func, ...)
    self = self:new('Action')
    self.__func = func
    self.__arguments = table.pack(...)
    return self
end


---@async
---Runs the action async and returns the result in a callback.
---@param cb function the callback function.
function Action:async(cb)
    self.__func(cb, table.unpack(self.__arguments))
end

---Runs this action in sync and returns the result.
---@return any? result the function results.
function Action:sync()
    local done = false
    local result = {}

    self:async(function(...)
        result = table.pack(...)
        done = true
    end, table.unpack(self.__arguments))

    while not done do
        Wait(10)
    end

    return table.unpack(result)
end