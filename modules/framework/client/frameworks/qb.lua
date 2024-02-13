---@diagnostic disable: duplicate-set-field

-- only run this file when using 'QB' framework
if not (Config.framework.name == "QB") then return end

local QBCore = exports[Config.framework.resource or 'qb-core']:GetCoreObject()

---@class CFramework
Framework = {}

---Show a notification with a message to the player.
---@param message string the message of the notification.
function Framework:notify(message) end


---Trigger a server callback.
---@param name string the name of the callback.
---@param cb function the callback function.
---@param ... any the data to send with this callback.
function Framework:triggerCallback(name, cb, ...) end


---Trigger a callback on the server, and wait for the response.
---@param name string the name of the callback.
---@param ... any the data to send with the callback.
---@return any result the callback result.
function Framework:triggerSyncCallback(name, ...) end


---Check if the player has loaded into his character.
---@return boolean loaded true if the player is completely loaded.
function Framework:isPlayerLoaded() return false end


---Waits for the player to be completely loaded into his character.
---Usually used when starting the script client-side, to make sure playerdata is available.
function Framework:awaitPlayerLoaded() end

---Returns the ammount of money the player has. For security reasons, the server-side function should
---also be called, when the player is trying, for example, to buy something.
---@param account string the name of the account to get the ammount of money from.
---@return integer amount the amount of money on that account.
function Framework:getAccountMoney(account) return 0 end

---Returns the job of this player. For security reasons this should also be checked on the server.<br>
---return format: `{ job: { name: string, label: string }, grade: { label: string, id: integer } }`
---@return FrameworkJobInfo|nil
function Framework:getJob() return nil end

---Returns all items the player currently has. For security reasons this should also be check on the server.<br>
---return format: `{ [itemName : string] = amount : integer }`
---@return FrameworkInventory|nil inventory
function Framework:getInventory() return nil end

---Returns the players weapons and ammo. For security reasons this should also be checked on the server.<br>
---return format: `{ [weaponName : string] = ammoCount : integer }`
---@return FrameworkLoadout|nil loadout
function Framework:getLoadout() return nil end

---Returns the players identity, with gender, height, firstname and lastname.
---return format: `{sex: boolean, height: integer, firstname: string, lastname: string}`
---@return FrameworkIdentity|nil
function Framework:getIdentity() return nil end


---This function registers a new event handler for money updates.
---This function should be used by HUDs.
---@param func function the function that will be called when the amount of money on an account changes. ```function(account : string, money : integer)```
function Framework:onAccountMoneyUpdate(func) end