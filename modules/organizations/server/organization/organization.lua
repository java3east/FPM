---Organizations are the classification of jobs. These objects are ment to manage funds, inventory usw. of these jobs.
---@class Organization : CLASS
---@field private __name string
Organization = CLASS:new('Organization')
Organization.__index = Organization

---Create a new organization object.
---@param name string the name of the organization, also known as job name.
---@return Organization organization
function Organization:new(name)
    local object = {}

    -- set meta table
    setmetatable(object, self)
    self.__index = self

    -- call constructor
    object:constructor(name)

    return object
end

---Sets the objects values
---@param name string the name of the organization, also known as job name.
function Organization:constructor(name)
    self.__name = name
end

---Returns the job of the organization.
---@return string name
function Organization:name()
    return self.__name
end

--[[
    ALL THE OTHER FUNCTIONS, SINCE THEY ARE FRAMEWORK RELATED, ARE LOCATED IN 'frameworks/*.lua'
]]