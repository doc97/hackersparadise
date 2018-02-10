local program = { args = {} }
local getDirectory = getDirectory

function program:onEnter()
    if #self.args < 1 then
        Terminal.workingDir = Systems[Terminal.ip].fs
        Terminal.workingDirPath = "/"
        Terminal:endProg()
        return
    end

    local dir, dirPath = getDirectory(Terminal.ip, Terminal.workingDirPath, self.args[1])
    if not dir then
        Terminal:endProg(-1, "NO SUCH DIRECTORY")
    else
        Terminal.workingDir = dir
        Terminal.workingDirPath = table.concat(dirPath)
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
