local program = { args = {} }
local getDirectory = getDirectory
local getFilename = getFilename

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "RM REQUIRES 1 PARAMETER: <FILE OR DIRECTORY>")
    else
        local parent, path = getDirectory(Terminal.workingDirPath, self.args[1] .. "/..")
        local file = getFilename(Terminal.workingDirPath, self.args[1])
        if not parent or not parent[file] then
            Terminal:endProg(-1, "NO SUCH FILE OR DIRECTORY")
        else
            parent[file] = nil
            Terminal:endProg()
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
