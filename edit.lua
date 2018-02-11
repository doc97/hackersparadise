local program = { args = {} }
local getFile = getFile
local getDirectory = getDirectory

local dir = {}
local filename = ""
local content = {}
local editLine = 1
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
        if i == editLine and cursorVisible then lineStr = lineStr .. cursor end
        love.graphics.print(lineStr, 16, 88 + (i - 1) * Fonts["bold-16"]:getHeight())
    end
end

function program:keypressed(key)
    if key == "backspace" then
        if content[editLine] == "" and #content > 1 then
            table.remove(content, editLine)
            editLine = editLine - 1
        else
            content[editLine] = string.sub(content[editLine], 1, -2)
        end
    elseif key == "return" then
        editLine = editLine + 1
        content[editLine] = ""
    elseif key == "tab" then
        dir[filename] = table.concat(content, "\n")
        Terminal:endProg()
    elseif key == "up" and editLine > 1 then
        editLine = editLine - 1
    elseif key == "down" and editLine < #content then
        editLine = editLine + 1
    end
end

function program:textinput(key)
    content[editLine] = content[editLine] .. string.upper(key)
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end

return program
