local screen = { }

local Fonts = Fonts
local continue = false
local selection = 1
local fontHeight = 0

local texts = { "EXIT", "NEW GAME", "CONTINUE" }
local selections = { }

function screen:onEnter()
    fontHeight = 1.5 * 24

    selections = { true, true, false }
    selections[3] = love.filesystem.getInfo("systems-save.lua") ~= nil
    selection = selections[3] and 3 or 2
end

function screen:onExit()

end

function screen:update(dt)

end

function screen:draw()
    love.graphics.setFont(Fonts["bold-48"])
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("HACKER'S PARADISE", 0, 100, love.graphics.getWidth(), "center")

    love.graphics.setFont(Fonts["bold-24"])
    love.graphics.printf("(WORKING TITLE)", 0, 180, love.graphics.getWidth(), "center")

    love.graphics.rectangle("fill", 40, love.graphics.getHeight() - 96 - selection * fontHeight, 10, fontHeight)
    love.graphics.rectangle("fill", 60, love.graphics.getHeight() - 96 - selection * fontHeight, 240, fontHeight)

    love.graphics.setColor(1, 1, 1)
    for i = #texts, 1, -1 do
        if selection == i then love.graphics.setColor(0, 0, 0)
        elseif not selections[i] then love.graphics.setColor(0.4, 0.4, 0.4)
		else love.graphics.setColor(1, 1, 1)
        end
		
        love.graphics.print(texts[i], 64, love.graphics.getHeight() - 96 - i * fontHeight)
    end

    love.graphics.setFont(Fonts["bold-12"])
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("(C) DANIEL RIISSANEN 2019", -48, love.graphics.getHeight() - 60,
        love.graphics.getWidth(), "right")
end

function screen:keypressed(key)
    if key == "return" then
        if selection == 1 then
            love.event.quit()
        elseif selection == 2 then
            Terminal:start()
            Terminal:newGame()
            Screens:setScreen("game")
        elseif selection == 3 then
            Terminal:start()
            Terminal:continueGame()
            Screens:setScreen("game")
        end
    elseif key == "up" and selection < 3 then
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
