---@diagnostic disable: duplicate-set-field

-- only run this file when using 'ESX' framework
if not (Config.framework.name == "ESX") then return end

ESX = exports[Config.framework.resource or "es_extended"]:getSharedObject()

---@class SFramework
Framework = {}

---Returns a new Player object. The player object contains the serverId of the player and his frameworkPlayerObject (in esx also known as xPlayer).
---Any other data, can be retrieved by calling a function of that object.
---@param id integer the players serverId
---@return Player|nil player the player object
function Framework:getPlayerFromId(id)
    local xPlayer = ESX.getPlayerFromId(id)
    return Player:new(id, xPlayer)
end

---Returns a new Player object. The player object contains the serverId of the player and his frameworkPlayerObject (in esx also known as xPlayer).
---Any other data, can be retrieved by calling a function of that object.
---@param identifier string the players identifier
---@return Player|nil player the player object
function Framework:getPlayerFromIdentifier(identifier)
    local xPlayer = ESX.getPlayerFromIdentifier(identifier)
    return Player:new(xPlayer.source, xPlayer)
end

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
    local xPlayer = self:getFrameworkPlayer()
    xPlayer.addAccountMoney(account, amount)
end

---Remove a given amount of money from the players account
---@param account string the name of the account to remove the money from.
---@param amount integer the amount of money to remove.
function Player:removeAccountMoney(account, amount)
    local xPlayer = self:getFrameworkPlayer()
    xPlayer.removeAccountMoney(account, amount)
end

---Give a new item to the player.
---@param itemName string the name of the item.
---@param amount integer the amount of items to give.
function Player:giveInventoryItem(itemName, amount)
    local xPlayer = self:getFrameworkPlayer()
    xPlayer.addInventoryItem(itemName, amount)
end

---Give a new weapon to the player.
---@param weaponName string the name of the weapon (e.g. 'weapon_pistol')
function Player:giveWeapon(weaponName)
    local xPlayer = self:getFrameworkPlayer()
    xPlayer:addWeapon(weaponName)
end

---Give the player ammonition for a specific weapon.
---@param weaponName string the name of the weapon to add the ammunition to.
---@param ammoCount integer the amount of ammunition to add.
function Player:giveWeaponAmmo(weaponName, ammoCount)
    local xPlayer = self:getFrameworkPlayer()
    xPlayer:addWeaponAmmo(weaponName, ammoCount)
end

---Add a component to the weapon of the player.
---@param weaponName string the name of the wepaon.
---@param componentName string the name of the component.
function Player:giveWeaponCompontent(weaponName, componentName)
    local xPlayer = self:getFrameworkPlayer()
    xPlayer:addWeaponComponent(weaponName, componentName)
end

---Get the amount of money the player has on a given account.
---@param account string the name of the account.
---@return integer amount the amount of money on that account.
function Player:getAccountMoney(account)
    local xPlayer = self:getFrameworkPlayer()
    return xPlayer.getAccount(account).money
end



-- The database module should be optional here.
-- If the module dose not exist, ignore the following part
if ORM == nil then return end

OfflinePlayer.addORM('getAccounts', ORM:New('users')
    :select()
        :column('accounts')
    :where()
        :column('identifier'):equals('@identifier')
    :applyOnResult('accounts', json.decode)
    :first()
    :prepare()
)

---Get the amount of money this player has.
---@param account string the name of the account.
---@return integer amount the amount of money on that account.
function OfflinePlayer:getAccountMoney(account)
    -- run orm query
    local result = OfflinePlayer.getORM('getAccounts'):query({ self.__identifier })

    -- return the result
    return result.accounts[account]
end

---Add money to a given account of the player.
---@param account string the account to add the money to.
---@param amount integer the amount of money to add.
function OfflinePlayer:addAccountMoney(account, amount) end

---Remove money from a given account of the player.
---@param account string the name of the account to remove the money from.
---@param amount integer the amount of money to remove.
function OfflinePlayer:removeAccountMoney(account, amount) end