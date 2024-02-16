-- ################################################################## --
-- #                                                                # --
-- #    This file is a part of the FPM (FiveM Project Manager),     # --
-- #                     created by Java3east.                      # --
-- #                                                                # --
-- ################################################################## --

---@class DebugConfig
---@field enable boolean true if debugging is enabled, false if not.

---@generic T
---@class Array<T> : {[integer] : T}

---@generic T
---@class Dictionary<T> : {[string] : T}

---@class Open : {[string] : {['server'|'client'] : {[string] : function}}}

---@class FrameworkConfig
---@field name 'ESX'|'QB'|'CUSTOM'
---@field resource string|nil

---@class FrameworkJobData
---@field name string the name / id of the job
---@field label string the label / display  name of the job

---@class FrameworkGradeData
---@field id integer the gradeId
---@field label string the label / display name of this grade

---@class FrameworkJobInfo
---@field job FrameworkJobData      job data
---@field grade FrameworkGradeData  grade data

---@class FrameworkInventory : {[string]: integer}

---@class FrameworkIdentity
---@field sex boolean the sex of the player
---@field height integer the height of the player
---@field firstname string the players firstname
---@field lastname string the players lastname

---@class FrameworkWeapon
---@field ammo integer
---@field components Array<string>
