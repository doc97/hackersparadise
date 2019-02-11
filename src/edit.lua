local program = { args = {} }
local getFile = getFile
local getDirectory = getDirectory

local dir = {}
local filename = ""
local content = {}
local editLine = 1
local cursorPos = 1
local cursor = "_"
local cursorVisible = false;
local blinkTimer = 0

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "EDIT REQUIRES 1 PARAMETER: <FILE>")
    else
        local text, path = getFile(Terminal.ip, Terminal.workingDirPath, self.args[1])
        dir = getDirectory(Terminal.ip, Terminal.workingDirPath, self.args[1] .. "/..")
        filename = getFilename(Terminal.workingDirPath, self.args[1])
        if not text then dir[filename] = "" end

        content = {}
        for c in string.gmatch(text or "", "[^\n]+") do content[#content + 1] = c end
        if #content == 0 then content[1] = "" end
        editLine = #content
        cursorPos = string.len(content[editLine]) + 1
    end
end

function program:update(dt)
    blinkTimer = blinkTimer + dt
    if blinkTimer > BLINK_TIME then
        blinkTimer = 0
        cursorVisible = not cursorVisible
    end
end

function program:draw()
    love.graphics.printf("EDITING FILE: " .. filename, 0, 16, love.graphics.getWidth(), "center")
    local lineStr = ""
    for i,line in ipairs(content) do
        lineStr = line
        if i == editLine then
            local lineStr1 = string.sub(lineStr, 1, cursorPos - 1)
            local lineStr2 = string.sub(lineStr, cursorPos)
            lineStr = lineStr1 .. (cursorVisible and cursor or " ") .. lineStr2
        end

        love.graphics.print(lineStr, 16, 88 + (i - 1) * Fonts["bold-16"]:getHeight())
    end
end

function program:keypressed(key)
    if key == "backspace" then
        if cursorPos == 1 then
            if editLine > 1 then
                local rest = string.sub(content[editLine], cursorPos)
                table.remove(content, editLine)
                editLine = math.max(1, editLine - 1)
                cursorPos = string.len(content[editLine]) + 1
                content[editLine] = content[editLine] .. rest
            end
        else
            local lineStr = content[editLine]
            content[editLine] = string.sub(lineStr, 1, cursorPos - 2) .. string.sub(lineStr, cursorPos)
            if cursorPos > 1 then cursorPos = cursorPos - 1 end
        end
    elseif key == "left" then
        if cursorPos > 1 then cursorPos = cursorPos - 1 end
    elseif key == "right" then
        if cursorPos <= string.len(content[editLine]) then cursorPos = cursorPos + 1 end
    elseif key == "return" then
        local lineStr = content[editLine]
        content[editLine] = string.sub(lineStr, 1, cursorPos - 1)
        editLine = editLine + 1
        table.insert(content, editLine, string.sub(lineStr, cursorPos))
        cursorPos = 1
    elseif key == "escape" then
        dir[filename] = table.concat(content, "\n")
        Terminal:endProg()
    elseif key == "up" and editLine > 1 then
        editLine = editLine - 1
        cursorPos =  math.min(cursorPos, string.len(content[editLine]) + 1)
    elseif key == "down" and editLine < #content then
        editLine = editLine + 1
        cursorPos =  math.min(cursorPos, string.len(content[editLine]) + 1)
    end
end

function program:textinput(key)
    local lineStr = content[editLine]
    content[editLine] = string.sub(lineStr, 1, cursorPos - 1) .. string.upper(key) .. string.sub(lineStr, cursorPos)
    cursorPos = cursorPos + 1
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end

return program
