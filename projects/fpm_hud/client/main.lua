-- cast to ignore type missmatches
Framework = Framework:cast('CFramework')

--- create a new CLASS hud, implementing 'IUI' to copy functionality
---@class HUD : CLASS, IUI
local HUD = CLASS:new('HUD', IUI)

---Update a given account on the hud.
---@param account FPMAccount
---@param amount integer
function HUD:updateAccount(account, amount)
    self.send('updateMoney', {
        account = account,
        amount = amount
    })
end


-- register the event for money updates
Framework:onAccountMoneyUpdate(function(account, amount)
    debug('Player account got updated: ' .. tostring(account) .. ' $' .. tostring(amount))
    HUD:updateAccount(account, amount)
end)

-- wait for the hud to load
Wait(1000)

--- wait for the player to load before setting the UI values
Framework:awaitPlayerLoaded()

debug("Player loaded!")

-- update banking money
local bankMoney = Framework:getAccountMoney(FPMAccount.BANK)
HUD:updateAccount(FPMAccount.BANK, bankMoney)

-- update cash money
local cashMoney = Framework:getAccountMoney(FPMAccount.MONEY)
HUD:updateAccount(FPMAccount.MONEY, cashMoney)