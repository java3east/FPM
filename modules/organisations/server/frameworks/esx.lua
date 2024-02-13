---@diagnostic disable: duplicate-set-field

-- make sure the right framework is being used.
if not Config.framework == "ESX" then return end

---Returns the ammount of money this organization has.
---@return integer money the amount of money
function Organization:getMoney()
    -- result variables, since esx event is async and we need a synced result
    local done = false
    local result = nil

    -- get account money
    TriggerEvent('esx_addonaccount:getSharedAccount', self.__name, function(sharedAccount)
        result = sharedAccount.money
        done = true
    end)

    -- wait for the result
    while not done do
        Wait(1)
    end

    -- return the result
    return result or 0
end

---Adds money to the organizations account.
---@param amount integer the amount of money to add.
function Organization:addMoney(amount)
    TriggerEvent('esx_addonaccount:getSharedAccount', self.__name, function(sharedAccount)
        sharedAccount.addMoney(amount)
    end)
end

---Remove money from the organizations account.
---@param amount integer the amount of money to remove.
function Organization:removeMoney(amount)
    TriggerEvent('esx_addonaccount:getSharedAccount', self.__name, function(sharedAccount)
        sharedAccount.removeMoney(amount)
    end)
end