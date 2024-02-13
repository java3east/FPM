---@class Player : CLASS
---@field private __id integer the players server id
---@field private __fPlayer table the framework player object
Player = CLASS:new('Player')

---Create a new player from his server id.
---@param id integer the players server id.
---@return Player player
function Player:new(id, fPlayer)
    local object = {}

    -- set meta table
    setmetatable(object, self)
    self.__index = self

    object:constructor(id, fPlayer)

    return object
end

---@param id integer the players server id
function Player:constructor(id, fPlayer)
    self.__id = id
    self.__fPlayer = fPlayer
end

---Returns the server id of the player.
---@return integer serverId
function Player:getId()
    return self.__id
end

---Returns the framework internal player. (in esx also known as 'xPlayer')
---@return table fPlayer
function Player:getFrameworkPlayer()
    return self.__fPlayer
end