---@class CLASS
---@field private __name string
---@field private __parents Array<CLASS>
CLASS = {}
CLASS.__index = CLASS

---Creates new CLASS object and returns it.<br>
---Creates a new CLASS object with a given name and a list of parents.
---@generic T
---@param name `T`
---@param ... CLASS the parent classes, `CLASS` will be added automatically.
---@return CLASS class
function CLASS:new(name, ...)
    local object = {}
    local parents = table.pack(...)

    -- set meta table
    setmetatable(object, {__index = function(table, key)
        for _, parent in ipairs(table.__parents) do
            -- get value from parent
            local value = parent[key]

            -- make sure value exists
            if not (value == nil) then
                -- add to local table for faster next search
                table[key] = value

                return value
            end
        end
    end})
    self.__index = self

    -- set values
    object.__name = name
    object.__parents = parents

    return object
end

---super constructor, called from subclasses,
---to fill in the required data for this parent class.
---@protected
---@abstract
---@param ... any
function CLASS:constructor(...) end


---Calls the super constructor of a given class, with a given set of arguments.
---@protected
---@generic T
---@param parent `T` the name of the parent class.
---@param ... any the arguements for the constructor.
function CLASS:super(parent, ...)
    for _, class in ipairs(self.__parents) do
        if class.__name == parent then
            class.constructor(self, ...)
        end
    end
end

---Returns itself, this function only exists to solve casting problems, avoid if possible.
---@generic T
---@param name `T` the name of the class this element should be casted to.
---@return T casted
function CLASS:cast(name) return self end

---Convert this object into a string.
---@return string str the class / object as string
function CLASS:toString() return tostring(self) end