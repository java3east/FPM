---@author Java3east [Discord: java3east]

---Clones a table with its subtables.
---@param tbl table the table to clone.
---@return table clone the cloned table.
function table.deepClone(tbl)
    local result = {}

    -- loop though the table
    for key, value in pairs(tbl) do

        -- check if value is a table
        if type(value) == "table" then
            -- value is a table => clone value
            result[key] = table.deepClone(value)
        else
            -- value is not a table => just apply
            result[key] = value
        end
    end

    return result
end

---Clones a table, this keeps the original subtables.
---@param tbl table the table to clone.
---@return table clone the cloned table.
function table.clone(tbl)
    local result = {}

    -- clone all values
    for key, value in pairs(tbl) do
        result[key] = value
    end

    return result
end

---Checks if a given value exists in a given table.
---@param tbl table the table to check if the value is in.
---@param value any the value to check if is included.
function table.contains(tbl, value)
    --- loop through the table and check if values match.
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

---Returns an array containing all the keys of the given table.
---@param tbl table the table to get the keys from.
---@return Array<any> keys the array of keys.
function table.keys(tbl)
    local keys = {}

    for key, _ in pairs(tbl) do
        table.insert(keys, key)
    end

    return keys
end

---Maps the table through a function, returning a table where every value is replace with the function return value.
---@param tbl table
---@param func function
---@return table output
function table.map(tbl, func)
    local output = {}

    for key, val in pairs(tbl) do
        output[key] = func(val)
    end

    return output
end

---Loops through an array and runs a function with the element as parameter.
---@param array Array<any> the array to loop through.
---@param func function the function to execute on each element.
function table.forEach(array, func)
    for _, element in ipairs(array) do
        func(element)
    end
end

---Returns the index of an element in a given array.
---@param array Array<any>
---@param value any
---@return integer index -1 if not found.
function table.indexOf(array, value)
    for index, v in ipairs(array) do
        if v == value then
            return index
        end
    end
    return -1
end