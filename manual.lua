local screen = { }
local Fonts = Fonts

local parts = { }
local partIndex = 1
local pageRows = { }
local pageIndex = 1
local pageStartIndex = 1
local err

function screen:loadParts()
    if #parts == 0 then
        parts, err = table.load("assets/manual-texts.lua")
        if err then print("Error loading manual texts!") parts = { } end
    end
end

function screen:loadPart(i)
    pageRows = { }
    partIndex = i
    pageIndex = 1
    pageStartIndex = 1
    headerCount = parts[partIndex] and #parts[partIndex].headers or 0
    local y = 88
    local rows = 1
    local index = 1
    for i = 1, headerCount, 1 do
        local str = parts[partIndex].headers[i]
        rows = 1
        for s in string.gmatch(str, "\n") do rows = rows + 1 end
        y = y + Fonts["bold-16"]:getHeight() * rows

        str = parts[partIndex].paragraphs[i]
        rows = 1
        for s in string.gmatch(str, "\n") do rows = rows + 1 end
        y = y + Fonts["bold-12"]:getHeight() * rows

        if y > love.graphics.getHeight() then
            pageRows[#pageRows + 1] = i - 1
            y = 88
        end
        index = i
    end
    pageRows[#pageRows + 1] = index

    if #pageRows == 0 then pageRows = { 0 } end
end

function screen:onEnter()
    self:loadParts()
    self:loadPart(1)
end

function screen:onExit() end

function screen:update(dt) end

function screen:draw()
    love.graphics.setColor(Systems[Terminal.ip].color)

    if not err then
        if #pageRows > 1 then
            love.graphics.setFont(Fonts["bold-16"])
            love.graphics.printf(pageIndex .. "/" .. #pageRows, -16, love.graphics.getHeight() - 32, love.graphics.getWidth(), "right")
        end

        love.graphics.setFont(Fonts["bold-24"])
        love.graphics.printf(parts[partIndex].title, 0, 32, love.graphics.getWidth(), "center")

        local y = 88
        for i = pageStartIndex, pageRows[pageIndex], 1 do
            local str = parts[partIndex].headers[i]
            local rows = 1
            for s in string.gmatch(str, "\n") do rows = rows + 1 end
            love.graphics.setFont(Fonts["bold-16"])
            love.graphics.print(str, 16, y) 
            y = y + Fonts["bold-16"]:getHeight() * rows

            str = parts[partIndex].paragraphs[i]
            rows = 1
            for s in string.gmatch(str, "\n") do rows = rows + 1 end
            love.graphics.setFont(Fonts["bold-12"])
            love.graphics.print(str, 16, y)
            y = y + Fonts["bold-12"]:getHeight() * rows
        end
    else
        love.graphics.setFont(Fonts["bold-24"])
        love.graphics.printf("ERROR LOADING TUTORIAL", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end

function screen:keypressed(key)
    if key == "tab" then
        Screens:setScreen("game")
    elseif key == "down" then
        if pageIndex < #pageRows then
            pageStartIndex = pageRows[pageIndex] + 1
            pageIndex = pageIndex + 1
        end
    elseif key == "up" then
        if pageIndex > 1 then
            pageIndex = pageIndex - 1
            pageStartIndex = (pageRows[pageIndex - 1] or 0) + 1
        end
    elseif key == "right" then
        if partIndex < #parts then
            self:loadPart(partIndex + 1)
        end
    elseif key == "left" then
        if partIndex > 1 then
            self:loadPart(partIndex - 1)
        end
    end
end

function screen:textinput(key) end

return screen
