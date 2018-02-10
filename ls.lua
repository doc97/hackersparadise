local program = { args = {} }
local getDirectory = getDirectory

function program:onEnter()
    local dir, dirPath = Terminal.workingDir, Terminal.workingDirPath
    if #self.args > 0 then
        dir, dirPath = getDirectory(Terminal.ip, Terminal.workingDirPath, self.args[1])
        if not dir then
            Terminal:endProg(-1, "NO SUCH DIRECTORY")
            return
        end
    end

    local strBuf = { "LIST OF FILES\n-------------\n" }

    for k,v in pairs(dir) do
        strBuf[#strBuf + 1] = string.upper(k)
        if type(v) == "table" then strBuf[#strBuf + 1] = "/" end
        strBuf[#strBuf + 1] = "\n"
    end
    Terminal:endProg(0, table.concat(strBuf))
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
