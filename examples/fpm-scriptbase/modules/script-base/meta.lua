---@author Java3east [Discord: java3east]

---@meta

---@class Array<T> : {[integer]: T} Represents an array of objects.
---@class Dictionary<T> : {[string]: T} Represents a dictionary of objects.

---@class Config : {[string]: table}
---@class Open : {[string]: {['server'|'client'] : Dictionary<string>}}

---@generic T
---@class DataPack<T> : {['__dpct__'] : `T`}