---@diagnostic disable: duplicate-set-field

-- make sure the right framework is being used.
if not Config.framework == "CUSTOM" then return end

---Returns the ammount of money this organization has.
---@return integer money the amount of money
function Organization:getMoney() return 0 end

---Adds money to the organizations account.
---@param amount integer the amount of money to add.
function Organization:addMoney(amount) end

---Remove money from the organizations account.
---@param amount integer the amount of money to remove.
function Organization:removeMoney(amount) end