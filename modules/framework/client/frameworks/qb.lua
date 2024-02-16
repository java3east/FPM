---@diagnostic disable: duplicate-set-field

-- only run this file when using 'QB' framework
if not (Config.framework.name == "QB") then return end

local QBCore = exports[Config.framework.resource or 'qb-core']:GetCoreObject()

---@class CFramework: CLASS
Framework = CLASS:new('CFramework')

---Show a notification with a message to the player.
---@param message string the message of the notification.
function Framework:notify(message)
    QBCore.Functions.Notify(message)
end


---Trigger a server callback.
---@param name string the name of the callback.
---@param cb function the callback function.
---@param ... any the data to send with this callback.
function Framework:triggerCallback(name, cb, ...)
    QBCore.Functions.TriggerCallback(name, cb, ...)
end


---Trigger a callback on the server, and wait for the response.
---@param name string the name of the callback.
---@param ... any the data to send with the callback.
---@return any result the callback result.
function Framework:triggerSyncCallback(name, ...)
    local done = false
    local data = {}

    -- trigger callback
    self:triggerCallback(name, function(...)
        data = table.pack(...)
    end, ...)

    -- wait for result
    while not done do
        Wait(10)
    end

    -- return
    return table.unpack(data)
end


---Check if the player has loaded into his character.
---@return boolean loaded true if the player is completely loaded.
function Framework:isPlayerLoaded()
    -- since I haven't found a direct function to check if the player got loaded, this has to be enough
    return not (QBCore.Functions.GetPlayerData() == nil)
end


---Waits for the player to be completely loaded into his character.
---Usually used when starting the script client-side, to make sure playerdata is available.
function Framework:awaitPlayerLoaded()
    -- if player is already done loading, return
    if self:isPlayerLoaded() then return end

    local loaded = false
    -- wait for the event
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        loaded = true
    end)

    -- wait for player to load
    while not loaded do
        Wait(10)
    end
end

---Returns the ammount of money the player has. For security reasons, the server-side function should
---also be called, when the player is trying, for example, to buy something.
---@param account string the name of the account to get the ammount of money from.
---@return integer amount the amount of money on that account.
function Framework:getAccountMoney(account)
    -- get playerdata
    local playerData = QBCore.Functions.GetPlayerData()
    -- return money
    return playerData.money[account]
end

---Returns the job of this player. For security reasons this should also be checked on the server.<br>
---return format: `{ job: { name: string, label: string }, grade: { label: string, id: integer } }`
---@return FrameworkJobInfo|nil
function Framework:getJob()
    -- get the player data
    local playerData = QBCore.Functions.GetPlayerData()

    -- return data
    return {
        job = {
            name = playerData.job.name,
            label = playerData.job.label
        },
        grade = {
            id = playerData.job.grade.level,
            label = playerData.job.grade.name
        }
    }
end

---Returns all items the player currently has. For security reasons this should also be check on the server.<br>
---return format: `{ [itemName : string] = amount : integer }`
---@return FrameworkInventory|nil inventory
function Framework:getInventory()
    -- item dictionary
    ---@type Dictionary<integer>
    local inventory = {}

    -- player data
    local playerData = QBCore.Functions.GetPlayerData()

    -- load inventory data into inventory table
    for _, item in ipairs(playerData.items) do
        inventory[item.name] = item.amount
    end

    return inventory
end

---Returns the players weapons and ammo. For security reasons this should also be checked on the server.<br>
---@return Dictionary<FrameworkWeapon>|nil loadout
function Framework:getLoadout()
    --- I haven't found any accessable data / function to fill this function, until that changes it will return an empty result :/
    return {}
end

---Returns the players identity, with gender, height, firstname and lastname.
---return format: `{sex: boolean, height: integer, firstname: string, lastname: string}`
---@return FrameworkIdentity|nil
function Framework:getIdentity()
    -- load playerData
    local playerData = QBCore.Functions.GetPlayerData()

    -- return formatted
    return {
        sex = playerData.charinfo.gender == 0 and Sex.MALE or Sex.FEMALE,
        height = 0, -- not found in playerData
        firstname = playerData.charinfo.firstname,
        lastname = playerData.charinfo.lastname
    }
end


---This function registers a new event handler for money updates.
---This function should be used by HUDs.
---@param func function the function that will be called when the amount of money on an account changes. ```function(account : string, money : integer)```
function Framework:onAccountMoneyUpdate(func)
    -- only event I found which has something to do with the money update
    RegisterNetEvent('QBCore:Player:SetPlayerData', function(playerData)
        -- update all accounts, since we don't know which one got udated, if any
        for account, money in ipairs(playerData.money) do
            func(account, money)
        end
    end)
end