local program = { args = {} }
local readFile = readFile

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "READ REQUIRES 1 PARAMETER: <FILE>")
    else
        local file = readFile(Terminal.workingDirPath, self.args[1])
        if not file then
            Terminal:endProg(-1, "NO SUCH FILE EXISTS")
        else
            Terminal:endProg(0, file)
        end
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
