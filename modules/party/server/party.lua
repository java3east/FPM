---@diagnostic disable: invisible
---@author Java3east [Discord: java3east]

---This class represents a serverside-party.
---@class SParty : CLASS
---@field private __leader PartyPlayer the party leaders serverId.
---@field private __members Array<PartyPlayer> array of party members.
---@field private __invites {[integer]: boolean} serverIds with player who got invited to the party.
Party = class('SParty')

---@type Array<SParty>
Party.__parties = {}

---Creates a new party, if the player is able to.
---@param player integer the players server id.
---@return boolean success true if the party got created, false if not.
---@return PartyRequestError? error an error code if the party creation failed.
---@diagnostic disable-next-line: duplicate-set-field
function Party.tryCreate(player)
    -- make sure the player is in no party
    local party = Party.get(player)
    if party then return false, PartyRequestError.ALREDY_IN_PARTY end

    -- create the new party
    Party:constructor(player)

    return true
end

---Returns the party the player is on or nil if the player is in no party.
---@param player integer the players server id.
---@return SParty? party
---@diagnostic disable-next-line: duplicate-set-field
function Party.get(player)
    local party = nil
    table.forEach(Party.__parties, function(element)
        if element:isMember(player) then
            party = element
        end
    end)
    return party
end

---Try to invite a player to the party.
---@param player integer the sending players server id.
---@param other integer the serverid of the player to invite to the party.
---@return boolean success true if the invitation was successful.
---@return PartyRequestError? error an error incase the creation was not successful.
function Party.tryInvite(player, other)
    -- make sure the player is in a party
    local party = Party.get(player)
    if not party then return false, PartyRequestError.NOT_IN_PARTY end

    -- make sure the player is the party leader
    if not (player == party:leaderId()) then return false, PartyRequestError.NOT_PARTY_LEADER end

    -- make sure the player exists
    if not DosePlayerExist(other) then return false, PartyRequestError.NOT_ONLINE end

    -- make sure other player is not yet in a party
    local otherParty = Party.get(other)
    if otherParty then return false, PartyRequestError.ALREDY_IN_PARTY end

    -- invite the player
    party:invite(other)

    return true
end

---Try to accept a party invitation
---@param player integer the serverId of the player who is trying to accept an invite.
---@param leaderId integer the serverId of the leader of the party the player is trying to join.
---@return boolean success true if the player joined successfuly
---@return PartyRequestError? error an error in case the joining failed.
function Party.tryAccept(player, leaderId)
    -- make sure the player is not yet in a party
    local party = Party.get(player)
    if party then return false, PartyRequestError.ALREDY_IN_PARTY end

    -- make sure the "leader" is online
    if not DosePlayerExist(leaderId) then return false, PartyRequestError.NOT_ONLINE end

    -- make sure "leader" is in a party
    party = Party.get(leaderId)
    if not party then return false, PartyRequestError.NOT_IN_PARTY end

    -- make sure the "leader" is the accutal party leader
    if not (party:leaderId() == leaderId) then return false, PartyRequestError.NOT_PARTY_LEADER end

    -- make sure the player has an invitation
    if not (party:hasInvitation(player)) then return false, PartyRequestError.NO_INVITATION end

    -- add the player to the party
    party:join(player)

    return true
end

---Trys to kick a player from a party.
---@param source integer the server id of the player who is trying to kick the player.
---@param player integer the player who should be kicked from the party.
---@return boolean success true if the player got kicked, false if not
---@return PartyRequestError? error an error in case the kick failed.
function Party.tryKick(source, player)
    -- make sure 'source' is in a party
    local party = Party.get(source)
    if not party then return false, PartyRequestError.NOT_IN_PARTY end

    -- make sure 'source' is the party leader
    if not party:leaderId() == source then return false, PartyRequestError.NOT_PARTY_LEADER end

    -- make sure 'player' is not the party leader
    if party:leaderId() == player then return false, PartyRequestError.ERROR end

    -- make sure 'player' is a member of that party
    if not party:isMember(player) then return false, PartyRequestError.NOT_IN_PARTY end

    -- kick the player
    party:kick(player)

    return true
end

---Removes the player savely from the pary.<br>
---@see Party.leave
---@param player any
function Party.quit(player)
    -- make sure the player is in a party
    local party = Party.get(player)
    if not party then return end

    -- remove the player from the party savely.
    party:leave(player)
end

---Crates a new Party object and returns it.
---@param leaderId integer the server id of the party leader.
---@return SParty party
---@diagnostic disable-next-line: duplicate-set-field
function Party:constructor(leaderId)
    self = self:new('SParty')

    self.__leader = PartyPlayer:constructor(leaderId)
    self.__members = {}
    self.__invites = {}

    table.insert(Party.__parties, self)

    TriggerEvent('fpm:party:event:created', self)

    return self
end

---Returns the serverId of the party leader.
---@return integer leaderId the leaders serverId.
function Party:leaderId()
    return self.__leader:id()
end

---Returns a list of party members.
---@param includeLeader boolean weather or not the party leader should be included in the list.
---@return Array<PartyPlayer> members array of members.
function Party:members(includeLeader)
    -- clone members table so we can add the leader, without adding him to the actuall member list
    local members = table.clone(self.__members)

    -- if the leader should not be included, we are done here.
    if not includeLeader then return members end

    -- add the leader
    table.insert(members, self.__leader:id())
    return members
end

---Checks if a given player is part of this party.
---@param player integer the players serverId.
---@return boolean isMember true if the player is a part of this party.
function Party:isMember(player)
    -- get the list of members
    local members = self:members(true)

    -- returns true if the player is a part of this party.
    return table.contains(members, player)
end

---Sends an event to all party members (including the leader).
---@param event string the name of the event.
---@param ... any the event data.
function Party:broadcast(event, ...)
    -- pack data to make it available in the forEach function
    local data = table.pack(...)

    -- loop through the players and trigger the event.
    table.forEach(self:members(true), function(member)
        TriggerClientEvent(event, member, table.unpack(data))
    end)
end

function Party:hasInvitation(player)
    return self.__invites[player]
end

---Invites a player to the party.
---@param player integer the server id of the player that should be invited.
---@diagnostic disable-next-line: duplicate-set-field
function Party:invite(player)
    -- remember the invitation
    self.__invites[player] = true

    -- tell the player he got invited.
    TriggerClientEvent('fpm:party:event:invite', player, self.__leader:name(), self.__leader:id())

    -- player party invite event
    TriggerEvent('fpm:party:event:invited', self, player)
end

---Adds a player to this party.
---@param player integer the server id of the joining player.
---@diagnostic disable-next-line: duplicate-set-field
function Party:join(player)
    -- create a new partyPlayer object
    local partyPlayer = PartyPlayer:constructor(player)

    -- tell the clients that a new player joined.
    self:broadcast('fpm:party:event:joined', partyPlayer:pack(), self:pack())

    -- add to member array
    table.insert(self.__members, partyPlayer)

    -- remove the player from the invitation list
    self.__invites[player] = false

    -- player party join event
    TriggerEvent('fpm:party:event:joined', self, partyPlayer)
end

---Savely removes a member from this party.<br>
---If the member to remove is the leader the first member of the member list will become the new party leader.<br>
---If the memberlist is empty, the party will be deleted.
---@param player integer the server id of the player who is leaving the party.
function Party:leave(player)
    -- make sure player is a member of this party
    if not self:isMember(player) then return end

    -- get the index of the player in the member list
    local index = table.indexOf(table.map(self.__members, function(v)
        return v:id()
    end), player)

    local partyPlayer

    -- player is the party leader and there for not in the memberlist
    if index == -1 then
        partyPlayer = self.__leader

        -- memberlist empty? => destroy party
        if not #self.__members > 0 then
            self:delete()
            return
        end

        -- new leader = first member
        self.__leader = self.__members[1]

        -- member to remove = first member (since now party leader)
        index = 1
    else
        partyPlayer = self.__members[index]
    end

    -- remove the member at the given index
    table.remove(self.__members, index)

    -- tell the clients that the player left
    self:broadcast('fpm:party:event:quit', partyPlayer:pack(), self:pack())

    -- server player party quit event
    TriggerEvent('fpm:party:event:quit', self, partyPlayer:pack())
end

---Kick the player from the party.<br>
---This will remove the player from the members list and trigger the kicked event.
---@param player integer the server id of the player who should get kicked
function Party:kick(player)
    -- get the index of the player in the member list
    local index = table.indexOf(table.map(self.__members, function(v)
        return v:id()
    end), player)

    -- make sure player is contained in the list
    if index == -1 then return end

    -- make the player leave
    self:leave(player)

    -- tell the player he got kicked
    TriggerClientEvent('fpm:party:event:kicked', player)
end

---Deletes this party.<br>
---This removes the party from the party list and triggers the `fpm:party:event:deleted` event.
function Party:delete()
    local index = table.indexOf(Party.__parties, self)

    -- make sure the party is in the party list
    if index == -1 then return end

    -- remove the party from the party list
    table.remove(Party.__parties, index)

    -- party deleted event
    TriggerEvent('fpm:party:event:deleted', self)
end

---Returns a datapack of this party.
---@return PartyData data
function Party:pack()
    return {
        leader = self.__leader:pack(),
        members = table.map(self.__members, function(member) return member:pack() end)
    }
end

ScriptBase.registerCallback('fpm:party:cb:create', Party.tryCreate)
ScriptBase.registerCallback('fpm:party:cb:invite', Party.tryInvite)
ScriptBase.registerCallback('fpm:party:cb:accept', Party.tryAccept)
ScriptBase.registerCallback('fpm:party:cb:kick', Party.tryKick)

RegisterNetEvent('fpm:party:event:quit', Party.quit)

AddEventHandler('playerDropped', function(reason)
    --- incase player is in a party, remove him.
    Party.quit(source)
end)