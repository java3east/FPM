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
---@class FrameworkLoadout : {[string]: integer}

---@class FrameworkIdentity
---@field sex boolean the sex of the player
---@field height integer the height of the player
---@field firstname string the players firstname
---@field lastname string the players lastname