---@fpm-ignore-start

---@type SFramework
Framework = {}

---@fpm-ignore-end

---@class Invoice : CLASS
---@field private __id string
---@field private __receiver InvoiceReceiver
---@field private __sender InvoiceReceiver
---@field private __reason string
---@field private __price integer
---@field private __note string
---@field private __due string
---@field private __payed boolean
Invoice = CLASS:new('Invoice')
Invoice.__index = Invoice

---Create a new Invoice object.
---@param id string the invoice id.
---@param receiver InvoiceReceiver the receiver of this invoice.
---@param sender InvoiceReceiver the sender of this invoice.
---@param reason string the reason for this invoice e.g. 'gave him a ride', 'helped him', 'other'.
---@param price integer the price of the invoice.
---@param note string an additional note.
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
---@param id string the invoice id.
---@param receiver InvoiceReceiver the receiver of this invoice.
---@param sender InvoiceReceiver the sender of this invoice.
---@param reason string the reason for this invoice e.g. 'gave him a ride', 'helped him', 'other'.
---@param price integer the price of the invoice.
---@param note string an additional note.
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
---@return string id
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
    -- TODO: register in database

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
    -- TODO: update `payed` in database

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
---@param account string the name of the account
---@return boolean successful true if the money got sent false if not
function Invoice:pay(account)
    -- make sure account exists (default: 'bank')
    account = account or "bank"

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