---Triggered when a new party got created.
---@param party SParty the created party.
AddEventHandler('fpm:party:event:created', function(party) end)

---Triggered when a player got invited to a party.
---@param party SParty the party the player got invited to.
---@param player integer the server id of the player who got invited.
AddEventHandler('fpm:party:event:invited', function(party, player) end)

---Triggered when a player joined a party.
---@param party SParty the party the player joined.
---@param player PartyPlayer the partyPlayer object of the player who joined the party.
AddEventHandler('fpm:party:event:joined', function(party, player) end)

---Triggered when a player leaves a party.
---@param party SParty the party the player was in.
---@param player PartyPlayer the partyPlayer object of the player who left the party.
AddEventHandler('fpm:party:event:quit', function(party, player) end)

---Triggered when a party got deleted.
---@param party SParty the party which got deleted.
AddEventHandler('fpm:party:event:deleted', function(party) end)