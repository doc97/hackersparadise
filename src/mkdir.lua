local program = { args = {} }
local getDirectory = getDirectory
local getFilename = getFilename

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "MKDIR REQUIRES 1 PARAMETER: <NAME>")
    end

    local dir, dirPath = getDirectory(Terminal.ip, Terminal.workingDirPath, self.args[1])
    if dir then
        Terminal:endProg(-1, "DIRECTORY ALREADY EXISTS")
    else
        local name = getFilename(Terminal.workingDirPath, self.args[1])
        local parent = getDirectory(Terminal.ip, Terminal.workingDirPath, self.args[1] .. "/..")
        parent[name] = { }
        Terminal:endProg()
    end
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end
function program:update(dt) end
function program:draw() end
function program:keypressed(key) end
function program:textinput(key) end

return program
