-- ################################################################## --
-- #                                                                # --
-- #    This file is a part of the FPM (FiveM Project Manager),     # --
-- #                     created by Java3east.                      # --
-- #                                                                # --
-- ################################################################## --

---@diagnostic disable: duplicate-set-field

-- only run this file when using 'CUSTOM' framework
if not (Config.framework.name == "CUSTOM") then return end

--[[  <<< LOAD YOUR FRAMEWORK RESOURCE HERE >>>  ]] --

---@class SFramework: CLASS
Framework = CLASS:new('SFramework')

---Returns a new Player object. The player object contains the serverId of the player and his frameworkPlayerObject (in esx also known as xPlayer).
---Any other data, can be retrieved by calling a function of that object.
---@param id integer the players serverId
---@return Player|nil player the player object
function Framework:getPlayerFromId(id) return nil end

---Returns a new Player object. The player object contains the serverId of the player and his frameworkPlayerObject (in esx also known as xPlayer).
---Any other data, can be retrieved by calling a function of that object.
---@param identifier string the players identifier
---@return Player|nil player the player object
function Framework:getPlayerFromIdentifier(identifier) return nil end

---Returns the frameworks account name for a given FPM account name.
---@param account FPMAccount fpm account name
---@return string name
function Framework:getAccountName(account) return account end

---Returns the FPM account name from the frameworks account name.
---@param account string framework account name.
---@return FPMAccount name
function Framework:getFPMAccountName(account) return account end

---Register a new ServerCallback.
---@param name string the name of the callback.
---@param func function the callback function. `function(source : integer, ... : any)`
function Framework:registerCallback(name, func) end

---Returns a OfflinePlayer object. Functions of this object get or set values in the database and should only be used if the player is not online.
---@param identifier string the identifier of the player
---@return OfflinePlayer offlinePlayer
function Framework:getOfflinePlayer(identifier) return OfflinePlayer:new(identifier) end

---Add money to the players account.
---@param account string the name of the account to add the money to.
---@param amount integer the amount of money to add to the account.
function Player:addAccountMoney(account, amount) end

---Remove a given amount of money from the players account
---@param account string the name of the account to remove the money from.
---@param amount integer the amount of money to remove.
function Player:removeAccountMoney(account, amount) end

---Give a new item to the player.
---@param itemName string the name of the item.
---@param amount integer the amount of items to give.
function Player:giveInventoryItem(itemName, amount) end

---Give a new weapon to the player.
---@param weaponName string the name of the weapon (e.g. 'weapon_pistol')
function Player:giveWeapon(weaponName) end

---Give the player ammonition for a specific weapon.
---@param weaponName string the name of the weapon to add the ammunition to.
---@param ammoCount integer the amount of ammunition to add.
function Player:giveWeaponAmmo(weaponName, ammoCount) end

---Add a component to the weapon of the player.
---@param weaponName string the name of the wepaon.
---@param componentName string the name of the component.
function Player:giveWeaponCompontent(weaponName, componentName) end

---Get the amount of money the player has on a given account.
---@param account string the name of the account.
---@return integer amount the amount of money on that account.
function Player:getAccountMoney(account) return 0 end
