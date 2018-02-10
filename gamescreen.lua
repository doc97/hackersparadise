require "commandcenter"
require "terminal"

local screen = { }

function screen:onEnter()
end

function screen:onExit()
    local err = table.save(Systems, "systems-save.lua")
    if err then print("Error: " .. err) end
    err = table.save(Settings, "settings-save.lua")
    if err then print("Error: " .. err) end
    err = table.save(Env, "env-save.lua")
    if err then print("Error: " .. err) end
end

function screen:update(dt)
    Terminal:update(dt)
    CC:update(dt)
end

function screen:draw()
    Terminal:draw()
end

function screen:keypressed(key)
    Terminal:keypressed(key)
end

function screen:textinput(key)
    Terminal:textinput(key)
end

return screen
