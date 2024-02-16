-- ################################################################## --
-- #                                                                # --
-- #    This file is a part of the FPM (FiveM Project Manager),     # --
-- #                     created by Java3east.                      # --
-- #                                                                # --
-- ################################################################## --

---@diagnostic disable: missing-fields
Config = {}


---@type DebugConfig
Config.debug = {}
--- Leave at false. This is a development setting.
Config.debug.enable = true


---framework config
---@type FrameworkConfig
Config.framework = {}
--- the name of the framework ('ESX' / 'QB' / 'CUSTOM')
Config.framework.name = 'ESX'
--- the name of the resource if not framework default (esx-default: 'es_extended', qb-default: 'qb-core')
Config.framework.resource = nil
