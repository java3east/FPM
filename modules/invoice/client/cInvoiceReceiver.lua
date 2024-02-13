---@class CInvoiceReceiver : CLASS
---@field private __isJob boolean true if the receiver is a job, false if the receiver is a player.
---@field private __identifier string the identifier of the receiver. (player identifier or job name)
CInvoiceReceiver = CLASS:new('CInvoiceReceiver')
CInvoiceReceiver.__index = CInvoiceReceiver

---Convert a string into an InvoiceReceiver
---@param str string
---@return CInvoiceReceiver|nil invoiceReceiver
function CInvoiceReceiver.fromString(str)
    -- split
    local receiverData = string.split(str, ":")
    
    -- make sure there are 2 arguments
    if not #receiverData == 2 then return nil end

    -- make sure first argument is 'job'/'identifier'
    if not (receiverData[1] == "job" or receiverData[1] == "identifier") then return nil end

    -- create InvoiceReceiver
    local isJob = receiverData[1] == "job"
    return CInvoiceReceiver:new(isJob, receiverData[2])
end

---Create a new InvoiceReceiver object.
---@param isJob boolean true if the reciever is a job.
---@param identifier string the identifier of the job / player.
---@return CInvoiceReceiver invoiceReceiver the receiver object.
function CInvoiceReceiver:new(isJob, identifier)
    local object = {}

    -- set the meta table
    setmetatable(object, self)
    self.__index = self

    -- set values
    object:constructor(isJob, identifier)

    return object
end

---Constructor
---@param isJob boolean true if the reciever is a job.
---@param identifier string the identifier of the job / player.
function CInvoiceReceiver:constructor(isJob, identifier)
    self.__isJob = isJob
    self.__identifier = identifier
end

---Check if the receiver is a job.
---@return boolean isJob
function CInvoiceReceiver:isJob()
    return self.__isJob
end

---Get the identifier / name of the receiver.
---@return string identifier
function CInvoiceReceiver:getIdentifier()
    return self.__identifier
end

function CInvoiceReceiver:toString()
    return self.__isJob and "job" or "identifier" .. ":" .. self.__identifier
end