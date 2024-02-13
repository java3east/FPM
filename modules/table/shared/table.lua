---Check if a given Array contains a given value.
---@param tbl Array<any>
---@param element any
---@return boolean contains
function table.contains(tbl, element)
    -- loop through all elements and check if the element matches with the given arguement.
    for _, elem in ipairs(tbl) do
        if elem == element then
            return true
        end
    end
    return false
end

---Joins together an array of elements into a string.
---@param array Array<any>
---@param seperator string
---@return string str
function table.join(array, seperator)
    local str = ""

    -- get the length of the array
    local arrayLength = #array

    -- loop through the array
    for i = 1, arrayLength, 1 do
        -- add the element
        str = str .. tostring(array[i])

        -- add a seperator if there is a next element
        if i < arrayLength then
            str = str .. seperator
        end
    end

    -- return the result
    return str
end