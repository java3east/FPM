--[[
    THIS FILE WILL BE REPLACED SOON, DUE TO A BAD CLASS STRUCTURE, BAD DOCUMENTATION,
    TYPE MISSMATCHES AND HIGH CHANCES FOR BUGS.
]]

---@diagnostic disable: param-type-mismatch
---@class ORM
---@field table string
---@field sql table|string
---@field sqlData table
---@field data table
---@field _first boolean
---@field format table
ORM = { table = "", sql = {}, sqlData = {}, data = {}, _first = false, format = {} }
ORM.__index = ORM


local function IsJunktion(str)
    local junktions = { "AND", "OR" }
    return table.contains(junktions, str)
end

---Create a new ORM object from a (database)table name.
---@param table string|table name the name of the table from the database.
---@return ORM orm the ORM object.
function ORM:New(table)
    local orm = {}
    setmetatable(orm, self)
    self.__index = self
    orm.sql = {}
    orm.data = {}
    orm._first = false
    orm.format = {}
    orm.sqlData = {}
    orm.table = table
    return orm
end

---Get the last sql argument
---@param i integer|nil 1 = last, 2 = second from last, ...
---@return table|nil last
function ORM:__last__(i)
    i = i or 1
    return self.sql[#self.sql + 1 - i]
end

function ORM:__extractCommand__(str)
    local commands = { "SELECT", "INSERT", "WHERE", "UPDATE", "ORDER" }
    for _, cmd in ipairs(commands) do
        if string.startsWith(str, cmd) then
            return cmd
        end
    end
    return nil
end

---@private
---@return string|ORM lastCommandName ["SELECT", "INSERT", "WHERE", "UPDATE"] or self
---@return integer|nil index index of the last command
function ORM:__lastCommand__()
    local lastCommand = nil
    local i = 1
    while not lastCommand do
        local lastArg = self:__last__(i)
        if not lastArg then
            return self
        end
        lastCommand = self:__extractCommand__(lastArg[1])
        i = i + 1
    end
    return lastCommand, i - 1
end

---@private
---@param orm ORM
---@param value any value for the function to execute
---@param tbl table containing keys with functions as value. keys should be ["SELECT", "INSERT", "WHERE", "UPDATE"]
function ORM:__performOnLast__(orm, value, tbl)
    tbl = tbl or {}
    local last = orm:__last__(1)
    if last then
        local lastCommand, i = orm:__lastCommand__()
        if tbl[lastCommand] then
            tbl[lastCommand](orm, value, i)
        end
    end
end

---@private
---@return string tableString the table name or names formatted as string
function ORM:__assembleTableString__()
    local tableString = ""
    if type(self.table) == "table" then
        for i = 1, #self.table, 1 do
            tableString = tableString .. "`" .. tostring(self.table[i]) .. "`"
            if i < #self.table then
                tableString = tableString .. ", "
            end
        end
    else
        tableString = "`" .. self.table .. "`"
    end
    return tableString
end

---@private
---@param name1 string table or column name
---@param name2 string|nil column name if first argument is a tableName
---@return string columnName the column name formatted as string (e.g. `table`.`column` or `column`)
function ORM:__assembleColName__(name1, name2)
    local name = ""

    if not (name1 == "*") then
        name1 = "`" .. name1 .. "`"
    end

    if name2 then
        if not (name2 == "*") then
            name2 = "`" .. name2 .. "`"
        end
        name = name1 .. "." .. name2
    else
        name = name1
    end
    return name
end

---Applies a function on all columns ```key``` of all results.
---@param key string the colum name to apply the function on.
---@param func function the function to run, the result will be the new result of this column.
---@return ORM self
function ORM:applyOnResult(key, func)
    self.format[key] = func
    return self
end

---Crate a new select query.
---@return ORM orm
function ORM:select()
    table.insert(self.sql, { "SELECT" })
    table.insert(self.sql, {})
    table.insert(self.sql, { "FROM " .. self:__assembleTableString__() })
    return self
end

---New insert
---@return ORM orm
function ORM:insert()
    table.insert(self.sql, { "INSERT INTO " .. self:__assembleTableString__() .. " (" })
    table.insert(self.sql, {})
    table.insert(self.sql, { ") VALUES (" })
    table.insert(self.sql, {})
    table.insert(self.sql, { ")" })
    return self
end

---New where
---@return ORM orm
function ORM:where()
    table.insert(self.sql, { "WHERE" })
    table.insert(self.sql, {})
    return self
end

function ORM:update()
    table.insert(self.sql, { "UPDATE " .. self:__assembleTableString__() .. " SET " })
    table.insert(self.sql, {})
    return self
end

---Add a collumn to the sql string.
---@param name string the column name
---@return ORM self
function ORM:column(name, name2)
    self:__performOnLast__(self, name, {
        SELECT = function(orm, value, index)
            value = self:__assembleColName__(name, name2)
            local last = orm:__last__(index - 1) or {}
            table.insert(last, value)
        end,
        INSERT = function(orm, value, index)
            value = self:__assembleColName__(name, name2)
            local last = orm:__last__(index - 1) or {}
            table.insert(last, value)
        end,
        WHERE = function(orm, value, index)
            value = self:__assembleColName__(name, name2)
            local last = orm:__last__(index - 1) or {}
            table.insert(last, value)
        end,
        UPDATE = function(orm, value, index)
            value = self:__assembleColName__(name, name2)
            local last = orm:__last__(index - 1) or {}
            table.insert(last, value)
        end
    })
    return self
end

---Create a new ```AND``` statement. Only applies on ```WHERE``` as last statement.
---@return ORM self
function ORM:AND()
    self:__performOnLast__(self, nil, {
        WHERE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            table.insert(last, "AND")
        end
    })
    return self
end

---Create a new ```OR``` statement. Only applies on ```WHERE``` as last statement.
---@return ORM self
function ORM:OR()
    self:__performOnLast__(self, nil, {
        WHERE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            table.insert(last, "OR")
        end
    })
    return self
end

---Add a value.
---@param value string|integer|number|table|nil|boolean
---@return ORM self
function ORM:value(value)
    self:__performOnLast__(self, value, {
        INSERT = function(orm, value, index)
            local last = orm:__last__(index - 3) or {}
            table.insert(last, "?")
            table.insert(orm.data, value)
        end,
        WHERE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = last[#last] .. "=?"
            table.insert(orm.data, value)
        end,
        UPDATE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = last[#last] .. "=?"
            table.insert(orm.data, value)
        end
    })
    return self
end

---```WHERE``` statement only. Checks if the last ````column(table, name)``` is equals to the value given.
---@see ORM.column
---@param value string|integer|number|table|nil|boolean
---@return ORM self
function ORM:equals(value)
    self:__performOnLast__(self, value, {
        WHERE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = last[#last] .. "=?"
            table.insert(orm.data, value)
        end
    })
    return self
end

---```WHERE``` statement only. Checks if the last ````column(table, name)``` is larger than the value given.
---@see ORM.column
---@param value number
---@return ORM self
function ORM:larger(value)
    self:__performOnLast__(self, value, {
        WHERE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = last[#last] .. ">?"
            table.insert(orm.data, value)
        end
    })
    return self
end

---Formats a selected column as date. Requires ```SELECT``` as last statement.
---@see ORM.column
---@param format string the format of the date.
---@return ORM self
function ORM:date(format)
    self:__performOnLast__(self, format, {
        SELECT = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = "DATE_FORMAT(" .. last[#last] .. ", '" .. value .. "')"
        end
    })
    return self
end

---Overwrite the name of a column returned from a ```SELECT``` statement.
---@see ORM.column
---@param value string
---@return ORM self
function ORM:as(value)
    self:__performOnLast__(self, value, {
        SELECT = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = last[#last] .. " AS `" .. value .. "`"
        end
    })
    return self
end

---Check if a ```column(table, name)``` is equals to a string (e.g. "%myString" '%' stands for any character of any count)
---@param value string
---@return ORM slef
function ORM:like(value)
    self:__performOnLast__(self, value, {
        WHERE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = last[#last] .. " LIKE ?"
            table.insert(orm.data, value)
        end
    })
    return self
end

---Check if the last ```column(table, name)``` of a ```WHERE``` statement is equals to a given `table`.`column`.
---@see ORM.column
---@see ORM.where
---@param name string table
---@param name2 string column
---@return ORM self
function ORM:equalsColumn(name, name2)
    name = self:__assembleColName__(name, name2)
    self:__performOnLast__(self, name, {
        WHERE = function(orm, value, index)
            local last = orm:__last__(index - 1) or {}
            last[#last] = last[#last] .. "=" .. value
        end
    })
    return self
end

---Only select x results
---@param limit integer|nil the maxium amount of entries to select if nil will result in 1
---@return ORM self
function ORM:limit(limit)
    limit = limit or 1
    table.insert(self.sql, { "LIMIT " .. limit })
    return self
end

---Set a index from where to start selecting the entries.
---@param offset integer|nil the index where to start selecting if nil overwritten with 0
---@return ORM self
function ORM:offset(offset)
    offset = offset or 0
    table.insert(self.sql, { "OFFSET " .. offset })
    return self
end

---Only select the first entry the database comes across.
---@return ORM self
function ORM:first()
    self:limit()
    self._first = true
    return self
end

---Order the results by a given column
---@param col string
---@return ORM self
function ORM:order(col)
    self:__performOnLast__(self, col, {
        WHERE = function(orm, value, index)
            table.insert(orm.sql, { "ORDER BY `" .. value .. "`" })
        end,
        SELECT = function(orm, value, index)
            table.insert(orm.sql, { "ORDER BY `" .. value .. "`" })
        end,
        ORDER = function(orm, value, index)
            table.insert(orm.sql, { ", `" .. value .. "`" })
        end
    })
    return self
end

function ORM:desc()
    table.insert(self.sql, { "DESC" })
    return self
end

function ORM:asc()
    table.insert(self.sql, { "ASC" })
    return self
end

function ORM:prepare()
    local query = ""
    local cmd = ""
    for index, element in ipairs(self.sql) do
        local extractCMDResult = self:__extractCommand__(element[1])
        if extractCMDResult then
            cmd = extractCMDResult
        end
        self.sqlData[index] = element
        local elementStr = table.join(element, ", ")
        if cmd ~= extractCMDResult then
            if cmd == "WHERE" then
                local i = 1
                elementStr = ""
                for _, str in ipairs(element) do
                    if i % 2 == 0 then
                        if not IsJunktion(str) then
                            elementStr = elementStr .. "AND " .. str
                        else
                            elementStr = elementStr .. str .. " "
                        end
                    else
                        elementStr = elementStr .. str .. " "
                    end
                    i = i + 1
                end
            end
        end
        query = query .. elementStr .. " "
    end
    self.sql = query:sub(1, -2)
    print("prepared: '" .. self.sql .. "'")
    return self
end

function ORM:query(table)
    if type(self.sql) == "table" then
        self.sql = self:prepare()
    end
    local data = {}
    if table then
        for index, value in ipairs(self.data) do
            for key, val in pairs(table) do
                if type(val) == "table" or type(val) == "vector3" then
                    val = json.encode(val)
                    table[key] = val
                end
                value = string.gsub(value, key, val)
            end
            data[index] = value
        end
    else
        data = self.data
    end
    local results = MySQL.query.await(self.sql, data)
    if results and type(results) == "table" then
        for _, result in ipairs(results) do
            for key, func in pairs(self.format) do
                if result[key] then
                    result[key] = func(result[key])
                end
            end
        end
        if self._first then
            if self.sqlData[1][1] == "SELECT" and #self.sqlData[2] == 1 and self.sqlData[2][1] ~= "*" then
                local key = self.sqlData[2][1]
                key = string.gsub(key, "`", "")
                return results[1][key]
            end
            return results[1]
        end
    end
    return results
end
