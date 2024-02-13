---@diagnostic disable: duplicate-set-field

-- only run this file when using 'QB' framework
if not (Config.framework.name == "QB") then return end

QBCore = exports[Config.framework.resource or 'qb-core']:GetCoreObject()

---@class SFramework
Framework = {}

---Returns a new Player object. The player object contains the serverId of the player and his frameworkPlayerObject (in esx also known as xPlayer).
---Any other data, can be retrieved by calling a function of that object.
---@param id integer the players serverId
---@return Player|nil player the player object
function Framework:getPlayerFromId(id)
    local qPlayer = QBCore.Functions.GetPlayer(id)
    return Player:new(id, qPlayer)
end

---Returns a new Player object. The player object contains the serverId of the player and his frameworkPlayerObject (in esx also known as xPlayer).
---Any other data, can be retrieved by calling a function of that object.
---@param identifier string the players identifier
---@return Player|nil player the player object
function Framework:getPlayerFromIdentifier(identifier) return nil end

---Returns a OfflinePlayer object. Functions of this object get or set values in the database and should only be used if the player is not online.
---@param identifier string the identifier of the player
---@return OfflinePlayer|nil offlinePlayer
function Framework:getOfflinePlayer(identifier)
    return OfflinePlayer:new(identifier)
end

---Add money to the players account.
---@param account string the name of the account to add the money to.
---@param amount integer the amount of money to add to the account.
function Player:giveAccountMoney(account, amount)
    local qPlayer = self:getFrameworkPlayer()
    qPlayer.Functions.AddMoney(account, amount)
end

---Remove a given amount of money from the players account
---@param account string the name of the account to remove the money from.
---@param amount integer the amount of money to remove.
function Player:removeAccountMoney(account, amount)
    local qPlayer = self:getFrameworkPlayer()
    qPlayer.Functions.RemoveMoney(account, amount)
end

---Give a new item to the player.
---@param itemName string the name of the item.
---@param amount integer the amount of items to give.
function Player:giveInventoryItem(itemName, amount)
    local qPlayer = self:getFrameworkPlayer()
    qPlayer:AddItem(self:getId(), itemName, amount)
end

---Give a new weapon to the player.
---@param weaponName string the name of the weapon (e.g. 'weapon_pistol')
function Player:giveWeapon(weaponName)
    self:giveInventoryItem(weaponName, 1)
end

---Give the player ammonition for a specific weapon.
---@param weaponName string the name of the weapon to add the ammunition to.
---@param ammoCount integer the amount of ammunition to add.
function Player:giveWeaponAmmo(weaponName, ammoCount)
    --- NO JUST NO!    
end

---Add a component to the weapon of the player.
---@param weaponName string the name of the wepaon.
---@param componentName string the name of the component.
function Player:giveWeaponCompontent(weaponName, componentName)
    --- WHAT THE HELL IS THIS FRAMEWORK????
end

---Get the amount of money the player has on a given account.
---@param account string the name of the account.
---@return integer amount the amount of money on that account.
function Player:getAccountMoney(account)
    local qPlayer = self:getFrameworkPlayer()
    return qPlayer.Functions.GetMoney(account)
end



-- The database module should be optional here.
-- If the module dose not exist, ignore the following part
if ORM == nil then return end

---Get the amount of money this player has.
---@param account string the name of the account.
---@return integer amount the amount of money on that account.
function OfflinePlayer:getAccountMoney(account) return 0 end

---Add money to a given account of the player.
---@param account string the account to add the money to.
---@param amount integer the amount of money to add.
function OfflinePlayer:addAccountMoney(account, amount) end

---Remove money from a given account of the player.
---@param account string the name of the account to remove the money from.
---@param amount integer the amount of money to remove.
function OfflinePlayer:removeAccountMoney(account, amount) end