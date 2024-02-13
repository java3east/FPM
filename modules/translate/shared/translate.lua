---@type Translator
local translator = translations {}

---This function is just syntetic sugar for Translator:new(translations)
---@param translations Dictionary<string>
---@return Translator
---@diagnostic disable-next-line: lowercase-global
function translations(translations)
    return Translator:new(translations)
end

---@class Translator : CLASS
---@field private __translations Dictionary<string>
Translator = CLASS:new('Translator')
Translator.__index = Translator

---Get the current active translator
---@return Translator translator
function Translator.get()
    return translator
end

function Translator:new(translations)
    local object = {}

    -- set meta table
    setmetatable(object, self)
    self.__index = self

    -- set values
    object:constructor(translations)

    return object
end

---Sets object values
---@param translations Dictionary<string>
function Translator:constructor(translations)
    self.__translations = translations
end

---Get the translation for a given key.
---@param key string
---@param replacements Dictionary<string>
function Translator:translate(key, replacements)
    --- get the value
    local value = self.__translations[key] or "UNKNOWN TRANSLATION"

    -- replace
    for k, v in ipairs(replacements) do
        value = value:gsub(k, v)
    end

    -- return
    return value
end