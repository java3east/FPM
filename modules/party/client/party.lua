---@author Java3east [Discord: java3east]

---@type CParty?
local party = nil

---@class CParty : CLASS
---@field private __leader PartyPlayer
---@field private __members Array<PartyPlayer>
CParty = class('CParty')

---Returns the current party
---@return CParty?
function CParty.get()
    return party
end

---Update the party data.
---@param data PartyData
function CParty.update(data)
    -- make sure player is in a party
    if not party then return end

    -- update leader if included
    if data.leader then
        party.__leader = DataPack.unpack(data.leader)
    end

    -- update members if included
    if data.members then
        party.__members = table.map(data.members, function(datapack)
            return DataPack.unpack(datapack)
        end)
    end
end

---Try to create a new party.
---@return boolean success true if the party got created.
---@return PartyRequestError? error an error in case the creation failed.
function CParty.create()
    -- try to create a party
    ---@type boolean, PartyRequestError?
    local success, error = ScriptBase.callback('fpm:party:cb:create'):sync()

    -- make sure the request got accepted
    if not success then return success, error end

    -- create a new party object
    party = CParty:constructor(NetworkGetNetworkIdFromEntity(PlayerPedId(-1)))

    return true
end


---Creates a new CParty object and retunrs it.
---@return CParty party the new party object.
function CParty:constructor(leader)
    self = self:new('CParty')
    self.__leader = leader
    self.__members = {}
    return self
end

---Returns an Array of party players.
---@param includeLeader boolean true if the party leader should be included in the returned array.
---@return Array<PartyPlayer> members an array of partyMembers.
function CParty:members(includeLeader)
    -- clone members table
    local members = table.clone(self.__members)

    -- break if leader should not be included
    if not includeLeader then return members end

    -- add leader to list
    table.insert(members, self.__leader)

    return members
end


---Triggered when a new player joins the party
---@param player DataPack<PartyPlayer>
---@param partydata PartyData
RegisterNetEvent('fpm:party:event:joined', function(player, partydata)
    -- make sure player is in a party
    if not party then return end

    --update the party
    CParty.update(partydata)

    -- player join event
    TriggerEvent('fpm:party:event:playerJoined', DataPack.unpack(player))
end)

---Triggered when a player left the party
---@param player DataPack<PartyPlayer>
---@param partydata PartyData
RegisterNetEvent('fpm:party:event:quit', function(player, partydata)
    -- make sure the player is in a party
    if not party then return end

    -- update the party
    CParty.update(partydata)

    -- player quit event
    TriggerEvent('fpm:party:event:playerQuit', DataPack.unpack(player))
end)