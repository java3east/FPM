---@fpm-ignore-start

---@type SFramework
local Framework = {}

---@fpm-ignore-end

---@class InvoiceReceiver : CLASS
---@field private __isJob boolean true if the receiver is a job, false if the receiver is a player.
---@field private __identifier string the identifier of the receiver. (player identifier or job name)
InvoiceReceiver = CLASS:new('InvoiceReceiver')
InvoiceReceiver.__index = InvoiceReceiver

---Convert a string into an InvoiceReceiver
---@param str string
---@return InvoiceReceiver|nil invoiceReceiver
function InvoiceReceiver.fromString(str)
    -- split
    local receiverData = string.split(str, ":")
    
    -- make sure there are 2 arguments
    if not #receiverData == 2 then return nil end

    -- make sure first argument is 'job'/'identifier'
    if not (receiverData[1] == "job" or receiverData[1] == "identifier") then return nil end

    -- create InvoiceReceiver
    local isJob = receiverData[1] == "job"
    return InvoiceReceiver:new(isJob, receiverData[2])
end

---Create a new InvoiceReceiver object.
---@param isJob boolean true if the reciever is a job.
---@param identifier string the identifier of the job / player.
---@return InvoiceReceiver invoiceReceiver the receiver object.
function InvoiceReceiver:new(isJob, identifier)
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
function InvoiceReceiver:constructor(isJob, identifier)
    self.__isJob = isJob
    self.__identifier = identifier
end

---Check if the receiver is a job.
---@return boolean isJob
function InvoiceReceiver:isJob()
    return self.__isJob
end

---Get the identifier / name of the receiver.
---@return string identifier
function InvoiceReceiver:getIdentifier()
    return self.__identifier
end

---Get the server id of this reciever
---@return integer serverId the serverId or -1 if not found.
function InvoiceReceiver:getServerId()
    -- get the receiver from his identifier
    local player = Framework:getPlayerFromIdentifier(self.__identifier)

    -- make sure the player exists
    if not player then return -1 end

    -- return the clients server id
    return player:getId()
end

function InvoiceReceiver:toString()
    return self.__isJob and "job" or "identifier" .. ":" .. self.__identifier
end