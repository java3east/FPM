---Debug to the console, if debug mode is active.
---@param ... any the data to print to the console, when debuging is active.
function debug(...)
    -- make sure debug mode is enabled
    if not Config.debug then return end

    -- print the given content to the console
    print(...)
end