local program = { args = {} }
local getFile = getFile
local getDirectory = getDirectory

local dir = {}
local filename = ""
local content = {}
local contentStr = ""
local contentDirty = false
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
        if not text then
            dir[filename] = ""
        else
            for c in string.gmatch(text, ".") do content[#content + 1] = c end
            contentDirty = true
        end
    end
end

function program:update(dt)
    blinkTimer = blinkTimer + dt
    if blinkTimer > BLINK_TIME then
        blinkTimer = 0
        cursorVisible = not cursorVisible
    end

    if contentDirty then
        contentStr = table.concat(content)
        contentDirty = false
    end
end

function program:draw()
    love.graphics.printf("EDITING FILE: " .. filename, 0, 16, love.graphics.getWidth(), "center")
    love.graphics.print(contentStr .. (cursorVisible and cursor or ""), 16, 88)
end

function program:keypressed(key)
    if key == "backspace" then
        content[#content] = nil
        contentDirty = true
    elseif key == "return" then
        content[#content + 1] = "\n"
        contentDirty = true
    elseif key == "tab" then
        dir[filename] = table.concat(content)
        Terminal:endProg()
    end
end

function program:textinput(key)
    content[#content + 1] = string.upper(key)
    contentDirty = true
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end

return program
