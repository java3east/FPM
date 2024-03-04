---@author Java3east [Discord: java3east]

ScriptBase = {}

---Returns the name of the active framework (ESX / QB / CUSTOM).<br>
---**This requires the framework to have its default resource name.**
---@return string frameworkName
function ScriptBase.GetFramework()
    if GetResourceState('es_extended') then return "ESX" end
    if GetResourceState('qb-core') then return "QB" end
    return "CUSTOM"
end