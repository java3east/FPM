---@author Java3east [Discord: java3east]

local classes = {}

---Creates a new class and returns it.
---@generic T
---@param name `T`
---@param ... CLASS?
---@return T class
function class(name, ...)
    local clazz = {}

    setmetatable(clazz, {
        __index = function (t, k)
            for _, parent in ipairs(t.__mt__) do
                local value = parent[k]
                if value then
                    t[k] = value
                    return value
                end
            end
        end
    })

    clazz.__clazz_name = name
    clazz.__mt__ = table.pack(...)
    table.insert(clazz.__mt__, CLASS)

    classes[name] = clazz

    return clazz
end

---@generic T
---@class CLASS
---@field private __clazz_name string the name of the class.
---@field private __mt__ Dictionary<CLASS>
CLASS = {}

---Returns the class given by its name
---@generic T : CLASS
---@param name `T`
---@return T
function CLASS.of(name)
    return classes[name]
end

---@protected
---@generic T : CLASS
---@param type `T`
---@return T object
function CLASS:new(type)
    local object = {}

    setmetatable(object, self)
    self.__index = self

    return object
end

---Classes constructor, should be overwritten by each class.
---@param ... any
function CLASS:constructor(...)
    self = self:new('CLASS')
    return self
end

function CLASS:super(parent, ...)
    local parent = self.__mt__[parent]
    if parent then
        parent.constructor(self, ...)
    end
end

---Returns the class name.
---@return string className
function CLASS:type()
    return self.__clazz_name
end