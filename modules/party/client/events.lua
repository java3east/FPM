---@author Java3east [Discord: java3east]

---Triggered when this player gets a party invitation.
---@param name string the name of the party leader.
---@param id integer the server id of the party leader.
RegisterNetEvent('fpm:party:event:invite', function(name, id) end)

---Triggered when this player got kicked from the party.
RegisterNetEvent('fpm:party:event:kicked', function() end)

---Triggered when a new player joined the party.
---@param partyPlayer PartyPlayer the player who joined.
AddEventHandler('fpm:party:event:playerJoined', function(partyPlayer) end)

---Triggered when a player left the party.
---@param partyPlayer PartyPlayer the player who left.
AddEventHandler('fpm:party:event:playerQuit', function(partyPlayer) end)