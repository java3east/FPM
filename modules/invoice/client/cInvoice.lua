---@class CInvoice : CLASS
---@field private __receiver CInvoiceReceiver
---@field private __sender CInvoiceReceiver
---@field private __reason string
---@field private __price integer
---@field private __note string
---@field private __due string
---@field private __payed boolean
CInvoice = CLASS:new('CInvoice')
CInvoice.__index = CInvoice

---Create a new Invoice object.
---@param receiver CInvoiceReceiver the receiver of this invoice.
---@param sender CInvoiceReceiver the sender of this invoice.
---@param reason string the reason for this invoice e.g. 'gave him a ride', 'helped him', 'other'.
---@param price integer the price of the invoice.
---@param note string an additional note.
---@param due string the date as string.
---@param payed boolean true if this invoice has been payed.
---@return Invoice invoice the invoice object
function CInvoice:new(receiver, sender, reason, price, note, due, payed)
    local object = {}

    -- set meta table
    setmetatable(object, self)
    self.__index = self

    -- call constructor
    object:constructor(receiver, sender, reason, price, note, due, payed)

    return object
end

---Sets the object values.
---@param receiver CInvoiceReceiver the receiver of this invoice.
---@param sender CInvoiceReceiver the sender of this invoice.
---@param reason string the reason for this invoice e.g. 'gave him a ride', 'helped him', 'other'.
---@param price integer the price of the invoice.
---@param note string an additional note.
---@param due string the date as string.
---@param payed boolean true if this invoice has been payed.
function CInvoice:constructor(receiver, sender, reason, price, note, due, payed)
    self.__receiver = receiver
    self.__sender = sender
    self.__reason = reason
    self.__price = price
    self.__note = note
    self.__due = due
    self.__payed = payed
end

---Get the receiver of this invoice.
---@return CInvoiceReceiver receiver
function CInvoice:getReceiver()
    return self.__receiver
end

---Get the sender of this invoice.
---@return CInvoiceReceiver sender
function CInvoice:getSender()
    return self.__sender
end

---Get the reason for this invoice.
---@return string reason
function CInvoice:getReason()
    return self.__reason
end

---Get the price of this invoice.
---@return integer price
function CInvoice:getPrice()
    return self.__price
end

---Get the additional note of this invoice.
---@return string note
function CInvoice:getNote()
    return self.__note
end

---Get the due date of this invoice.
---@return string due
function CInvoice:getDue()
    return self.__due
end

---Check if this invoice has been payed.
---@return boolean payed
function CInvoice:isPayed()
    return self.__payed
end

function CInvoice:toString()
    return "Invoice{receiver=" ..
    self.__receiver:toString() ..
    ",sender=" .. self.__sender:toString() ..
    ",reason='".. self.__reason .. "'" ..
    ",price=" .. tostring(self.__price) ..
    ",note='"..self.__note.."'" ..
    ",due='" .. self.__due .. "'" ..
    ",payed=" .. tostring(self.__payed) ..
    "}"
end