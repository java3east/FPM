---Split a string and return as array
---@param str string
---@param delimiter string
---@return Array<string>
function string.split(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

---Generates a new random string with a given length.
---@param length integer
---@return string
function string.random(length)
    -- available chars
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    local str = ""

    -- generate string
    for i = 0, length, 1 do
        -- get a random index from 1 to chars.length
        local index = math.random(string.len(chars))
        
        -- get the char at that index
        local char = chars:gsub(index, index)

        -- add the char to the random string
        str = str .. char
    end

    return str
end

---Check if the strings starts with a given string.
---@param str string
---@param other string
---@return boolean
function string.startsWith(str, other)
    return str:sub(1, other:len()) == other
end