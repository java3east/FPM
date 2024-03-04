---@class PartyPlayer : CLASS
---@field private __serverId integer the players serverId
---@field private __name string the players name
PartyPlayer = class('PartyPlayer')

---Creates a new PartyPlayer from a datapack
---@param data any
---@return PartyPlayer
function PartyPlayer.from(data)
    local partyPlayer = PartyPlayer:new('PartyPlayer')
    partyPlayer.__serverId = data.id
    partyPlayer.__name = data.name
    return partyPlayer
end

---Creates and returns a new PartyPlayer object from its serverId.
---@param serverId integer the players serverId.
---@return PartyPlayer partyPlayer the partyPlayer object.
function PartyPlayer:constructor(serverId)
    self = self:new('PartyPlayer')
    self.__serverId = serverId
    self.__name = GetPlayerName(serverId)
    return self
end

---Returns the players server id.
---@return integer serverId
function PartyPlayer:id()
    return self.__serverId
end

---Returns the players name.
---@return string name
function PartyPlayer:name()
    return self.__name
end

---Creates and returns a datapack containing information about this object.
---@return DataPack<PartyPlayer> data
function PartyPlayer:pack()
    return {
        __dpct__ = self:type(),
        id = self.__serverId,
        name = self.__name
    }
end