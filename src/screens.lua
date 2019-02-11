Screens = {
    ["manual"] = assert(love.filesystem.load("manual.lua"))(),
    ["mainmenu"] = assert(love.filesystem.load("menuscreen.lua"))(),
    ["game"] = assert(love.filesystem.load("gamescreen.lua"))(),
}

CurrentScreen = nil

function Screens:setScreen(name)
    if Screens[name] and Screens[name] ~= CurrentScreen then
        CurrentScreen:onExit()
        CurrentScreen = Screens[name]
        CurrentScreen:onEnter()
    end
end

