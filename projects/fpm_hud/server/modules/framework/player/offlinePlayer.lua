-- ################################################################## --
-- #                                                                # --
-- #    This file is a part of the FPM (FiveM Project Manager),     # --
-- #                     created by Java3east.                      # --
-- #                                                                # --
-- ################################################################## --

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