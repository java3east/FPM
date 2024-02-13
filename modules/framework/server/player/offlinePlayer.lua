---@class OfflinePlayer : CLASS
---@field private __identifier string
OfflinePlayer = CLASS:new('OfflinePlayer')
OfflinePlayer.__index = OfflinePlayer

---@private
OfflinePlayer.__sql = {}

---Create a new offline player object.
---@param identifier string the players identifier.
---@return OfflinePlayer offlinePlayer
function OfflinePlayer:new(identifier)
    local object = {}

    -- set the metatable
    setmetatable(object, self)
    object.__index = object

    -- set object values
    object:constructor(identifier)

    return object
end

---Set the objects values
---@param identifier string the players identifier
function OfflinePlayer:constructor(identifier)
    self.__identifier = identifier
end

-- The database module should be optional here.
-- If the module dose not exist, ignore the following part
if ORM == nil then return end

---Adds a new ORM query to this object.
---@param name string
---@param orm ORM
function OfflinePlayer.addORM(name, orm)
    OfflinePlayer.__sql[name] = orm
end

---Get an orm object from its name
---@param name string
---@return ORM orm
function OfflinePlayer.getORM(name)
    return OfflinePlayer.__sql[name]
end