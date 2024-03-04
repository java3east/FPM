---@class DataPack<T>
DataPack = class('DataPack')

---Projects the data of this datapack onto a given class.
---@private
---@generic T
---@param datapack DataPack<T>
---@return T
function DataPack.unpack(datapack)
    return CLASS.of(datapack.__dpct__):from(datapack)
end