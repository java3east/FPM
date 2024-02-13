---@fpm-ignore-start
---@type Open
Open = {}
---@fpm-ignore-end
Open.framework = {}

--- open server functions
Open.framework.server = {}

--- open client functions
Open.framework.client = {}

---Send a notification to the client.
---@param message string the message to show
---@return boolean used true if this function was used.
function Open.framework.client:notify(message) return false end