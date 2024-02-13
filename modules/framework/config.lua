---@fpm-ignore-start
---@diagnostic disable: missing-fields
Config = {}
---@fpm-ignore-end

---framework config
---@type FrameworkConfig
Config.framework = {}
--- the name of the framework ('ESX' / 'QB' / 'CUSTOM')
Config.framework.name = 'ESX'
--- the name of the resource if not framework default (esx-default: 'es_extended', qb-default: 'qb-core')
Config.framework.resource = nil