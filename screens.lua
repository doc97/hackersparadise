Screens = {
    ["manual"] = dofile("manual.lua"),
    ["mainmenu"] = dofile("menuscreen.lua"),
    ["game"] = dofile("gamescreen.lua"),
}

CurrentScreen = nil

function Screens:setScreen(name)
    if Screens[name] and Screens[name] ~= CurrentScreen then
        CurrentScreen:onExit()
        CurrentScreen = Screens[name]
        CurrentScreen:onEnter()
    end
end

