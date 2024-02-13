---@fpm-ignore-start

---@type SFramework
Framework = {}

---@fpm-ignore-end

local register = ORM:New('invoices')
    :insert()
        :column('receiver'):value('@receiver')
        :column('sender'):value('@sender')
        :column('reason'):value('@reason')
        :column('price'):value('@price')
        :column('note'):value('@note')
        :column('due'):value('@due')
        :column('payed'):value('@payed')
:prepare()

local update = ORM:New('invoices')
    :update()
        :column('payed'):value('@payed')
    :where()
        :column('id'):value('@id')
:prepare()

local load = ORM:New('invoices')
    :select()
        :column('*')
    :where()
        :column('receiver'):value('@identifier')
    :applyOnResult('receiver', InvoiceReceiver.fromString)
    :applyOnResult('sender', InvoiceReceiver.fromString)
:prepare()

local loadAll = ORM:New('invoices')
    :select()
        :column('*')
    :where()
        :column('receiver'):value('@identifier')
        :column('sender'):value('@identifier')
    :applyOnResult('receiver', InvoiceReceiver.fromString)
    :applyOnResult('sender', InvoiceReceiver.fromString)
:prepare()

---@class Invoice : CLASS
---@field private __id integer
---@field private __receiver InvoiceReceiver
---@field private __sender InvoiceReceiver
---@field private __reason string
---@field private __price integer
---@field private __note string
---@field private __due string
---@field private __payed boolean
Invoice = CLASS:new('Invoice')
Invoice.__index = Invoice

---Creates a new Invoice, saves it in the database and returns it
---@param receiver InvoiceReceiver
---@param sender InvoiceReceiver
---@param reason string
---@param price integer
---@param note string
---@param due string
---@return Invoice invoice
function Invoice.create(receiver, sender, reason, price, note, due)
    -- create new invoice object
    local invoice = Invoice:new(0, sender, receiver, reason, price, note, due, false)

    -- register
    invoice:register()

    -- return
    return invoice
end

---Get a players / organizations invoices
---@param invoiceReceiver InvoiceReceiver
---@param all boolean if true, this will load sent and received invoices, if false, only received invoices will be returned.
function Invoice.get(invoiceReceiver, all)
    local results

    if all then
        results = loadAll:query({ ['@identifier'] = invoiceReceiver:toString() })
    else
        results = load:query({ ['@identifier'] = invoiceReceiver:toString() })
    end

    --- create invoice objects from the results
    local invoices = {}
    for _, entry in ipairs(results) do
        -- get InvoiceReceiver objects from their string. No creation of InvoiceReceivers nesessary, since they are already build after executing the query.
        -- => see: ORM.applyOnResult
        table.insert(invoices, Invoice:new(entry.id, entry.receiver, entry.sender, entry.reason, entry.price, entry.note, entry.due, entry.payed))
    end
end

---Create a new Invoice object.
---@param id integer the invoice id.
---@param receiver InvoiceReceiver the receiver of this invoice.
---@param sender InvoiceReceiver the sender of this invoice.
---@param reason string the reason for this invoice (short description)
---@param price integer the price of the invoice.
---@param note string an additional note (long description)
---@param due string the date as string.
---@param payed boolean true if this invoice has been payed.
---@return Invoice invoice the invoice object
function Invoice:new(id, receiver, sender, reason, price, note, due, payed)
    local object = {}

    -- set meta table
    setmetatable(object, self)
    self.__index = self

    -- call constructor
    object:constructor(id, receiver, sender, reason, price, note, due, payed)

    return object
end

---Sets the object values.
---@param id integer the invoice id.
---@param receiver InvoiceReceiver the receiver of this invoice.
---@param sender InvoiceReceiver the sender of this invoice.
---@param reason string the reason for this invoice (short description)
---@param price integer the price of the invoice.
---@param note string an additional note (long description)
---@param due string the date as string.
---@param payed boolean true if this invoice has been payed.
function Invoice:constructor(id, receiver, sender, reason, price, note, due, payed)
    self.__id = id
    self.__receiver = receiver
    self.__sender = sender
    self.__reason = reason
    self.__price = price
    self.__note = note
    self.__due = due
    self.__payed = payed
end

---Get the id of this invoice.
---@return integer id
function Invoice:getId()
    return self.__id
end

---Get the receiver of this invoice.
---@return InvoiceReceiver receiver
function Invoice:getReceiver()
    return self.__receiver
end

---Get the sender of this invoice.
---@return InvoiceReceiver sender
function Invoice:getSender()
    return self.__sender
end

---Get the reason for this invoice.
---@return string reason
function Invoice:getReason()
    return self.__reason
end

---Get the price of this invoice.
---@return integer price
function Invoice:getPrice()
    return self.__price
end

---Get the additional note of this invoice.
---@return string note
function Invoice:getNote()
    return self.__note
end

---Get the due date of this invoice.
---@return string due
function Invoice:getDue()
    return self.__due
end

---Check if this invoice has been payed.
---@return boolean payed
function Invoice:isPayed()
    return self.__payed
end

---create this invoice in the database.
function Invoice:register()
    -- save in database
    self.__id = register:insertSQL({
        ['@receiver'] = self.__receiver:toString(),
        ['@sender'] = self.__sender:toString(),
        ['@reason'] = self.__reason,
        ['@price'] = self.__price,
        ['@note'] = self.__note,
        ['@due'] = self.__due,
        ['@payed'] = self.__payed
    })

    -- call open function
    Open.invoice.server:onInvoiceCreated(self)

    -- get the serverId of the receiver
    local receiverServerId = self.__receiver:getServerId()

    -- make sure the receiver is online
    if receiverServerId == -1 then return end

    -- inform the clients about the update
    TriggerClientEvent('fpm:invoice:new', receiverServerId, self:pack())
end

---Updates the status of this invoice. This also affects the database.<br>
---This also informs the client through a `fpm:invoice:payed` event.
function Invoice:setPayed()
    -- update `payed` in database
    update:query({
        ['@payed'] = true,
        ['@id'] = self.__id
    })

    -- change payed status
    self.__payed = true

    -- call open function
    Open.invoice.server:onInvoicePayed(self)

    -- get the serverId of the receiver
    local receiverServerId = self.__receiver:getServerId()

    -- make sure the receiver is online
    if receiverServerId == -1 then return end

    -- inform the client about the update
    TriggerClientEvent('fpm:invoice:payed', receiverServerId, self:pack())
end

---Try to pay the invoice. This will, if possible remove the amount of money from the given account (usually 'bank') and<br>
---and give it to the invoice sender. This also marks the Invoice as payed.<br> In case the player is offline this will<br>
---be directly changed in the database.
---@see Invoice.setPayed
---@param account FPMAccount the name of the account
---@return boolean successful true if the money got sent false if not
function Invoice:pay(account)
    -- make sure account exists (default: FPMAccount.BANK)
    account = account or FPMAccount.BANK

    -- get identifiers
    -- BECAREFUL: RECEIVER REFFERS TO THE INVOICE RECEIVER, NOT THE RECEIVER OF THE MONEY
    local receiverIdentifier = self.__receiver:getIdentifier()
    local senderIdentifier = self.__sender:getIdentifier()


    -- check if receiver is a job (organization)
    if self.__receiver:isJob() then
        -- organization

        -- get the organization
        local organization = Organization:new(receiverIdentifier)

        -- make sure they have enough money
        local money = organization:getMoney()
        if money < self.__price then return false end

        -- remove the money
        organization:removeMoney(self.__price)
    else
        -- player

        -- get receiver
        ---@type Player|OfflinePlayer|nil
        local receiver = Framework:getPlayerFromIdentifier(receiverIdentifier)

        --- receiver is offline => get offline player
        if not receiver then
            receiver = Framework:getOfflinePlayer(receiverIdentifier)
        end

        -- make sure receiver has enough money to cover the bill
        local money = receiver:getAccountMoney(account)
        if money < self.__price then return false end

        -- remove the money
        receiver:removeAccountMoney(account, self.__price)
    end


    -- check if sender is a job (organization)
    if self.__sender:isJob() then
        -- organization

        -- get the organization
        local organization = Organization:new(senderIdentifier)

        -- add money to the account of the organization
        organization:addMoney(self.__price)
    else
        -- player

        --get sender
        ---@type Player|OfflinePlayer|nil
        local sender = Framework:getPlayerFromIdentifier(senderIdentifier)

        --sender is offline => get offline Player
        if not sender then
            sender = Framework:getOfflinePlayer(senderIdentifier)
        end

        -- add money to the senders account
        sender:addAccountMoney(account, self.__price)
    end

    -- success
    return true
end

---convert this Invoice into a jsonable table.
---@return table
function Invoice:pack()
    return {
        id = self.__id,
        receiver = self.__receiver:toString(),
        sender = self.__sender:toString(),
        reason = self.__reason,
        price = self.__price,
        note = self.__note,
        due = self.__due,
        payed = self.__payed
    }
end

function Invoice:toString()
    return "Invoice{" ..
    "id='" .. self.__id .. "'" ..
    ",receiver=" .. self.__receiver:toString() ..
    ",sender=" .. self.__sender:toString() ..
    ",reason='".. self.__reason .. "'" ..
    ",price=" .. tostring(self.__price) ..
    ",note='"..self.__note.."'" ..
    ",due='" .. self.__due .. "'" ..
    ",payed=" .. tostring(self.__payed) ..
    "}"
end