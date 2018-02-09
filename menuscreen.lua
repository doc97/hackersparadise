local screen = { }

local Fonts = Fonts
local continue = false
local selection = 1
local fontHeight = 0

local texts = { "EXIT", "CREDITS", "NEW GAME", "CONTINUE" }
local selections = { }

function screen:onEnter()
    fontHeight = 1.5 * 24

    selections = { true, false, true, false }
    selections[4] = love.filesystem.exists("systems-save.lua")
    selection = selections[4] and 4 or 3
end

function screen:onExit()

end

function screen:update(dt)

end

function screen:draw()
    love.graphics.setFont(Fonts["bold-48"])
    love.graphics.setColor(255, 255, 255)
    love.graphics.printf("HACKER'S PARADISE", 0, 100, love.graphics.getWidth(), "center")

    love.graphics.setFont(Fonts["bold-24"])
    love.graphics.printf("(WORKING TITLE)", 0, 180, love.graphics.getWidth(), "center")

    love.graphics.rectangle("fill", 40, love.graphics.getHeight() - 96 - (selection - 1) * fontHeight, 10, fontHeight)
    love.graphics.rectangle("fill", 60, love.graphics.getHeight() - 96 - (selection - 1) * fontHeight, 240, fontHeight)

    love.graphics.setColor(255, 255, 255)
    for i = #texts, 1, -1 do
        if selection == i then love.graphics.setColor(0, 0, 0)
        elseif not selections[i] then love.graphics.setColor(100, 100, 100)
        end
        love.graphics.print(texts[i], 64, love.graphics.getHeight() - 96 - (i - 1) * fontHeight)
        love.graphics.setColor(255, 255, 255)
    end
end

function screen:keypressed(key)
    if key == "return" then
        if selection == 1 then
            love.event.quit()
        elseif selection == 3 then
            Terminal:start()
            Terminal:newGame()
            Screens:setScreen("game")
        elseif selection == 4 then
            Terminal:start()
            Terminal:continueGame()
            Screens:setScreen("game")
        end
    elseif key == "up" and selection < 4 then
        local index = selection
        repeat
            index = index + 1
            if selections[index] then
                selection = index
                break
            end
        until index > #selections
    elseif key == "down" and selection > 1 then
        local index = selection
        repeat
            index = index - 1
            if selections[index] then
                selection = index
                break
            end
        until index < 1
    end
end

function screen:textinput(key)

end

return screen
