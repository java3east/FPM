---@diagnostic disable: duplicate-set-field

-- make sure the right framework is being used.
if not Config.framework == "QB" then return end

--[[
    QB saves the funds directly into the database. At least that is what I have seen, but
    I don't know to much about QBCore, so if you know a different and better way of doing this,
    please tell me or make a pull request.
]]

--- get query
local get = ORM:New('management_funds')
    :select()
        :column('amount')
    :where()
        :column('job_name'):equals('@name')
    :first()
:prepare()

--- set query
local set = ORM:New('management_funds')
    :update()
        :column('amount'):value('@amount')
    :where()
        :column('job_name'):equals('@name')
:prepare()

---Returns the ammount of money this organization has.
---@return integer money the amount of money
function Organization:getMoney()
    -- load from database
    local result = get:query({ ['@name'] = self.__name })

    -- cast to integer, this is possible, since we are only loading a single column, from a single result.
    ---@cast result integer

    -- return the result
    return result
end

---Adds money to the organizations account.
---@param amount integer the amount of money to add.
function Organization:addMoney(amount)
    -- get current money
    local money = self:getMoney()

    -- add
    money = money + amount

    -- save
    set:query({ ['@amount'] = money, ['@name'] = self.__name })
end

---Remove money from the organizations account.
---@param amount integer the amount of money to remove.
function Organization:removeMoney(amount)
    -- get current money
    local money = self:getMoney()

    -- remove
    money = money - amount

    -- save
    set:query({ ['@amount'] = money, ['@name'] = self.__name })
end