local program = { args = {} }

function program:onEnter()
    if #self.args < 2 then
        Terminal:endProg(-1, "MV REQUIRES 2 PARAMETERS: <SRC> <DST>")
    else
        local src, dest = Terminal.workingDir[self.args[1]], Terminal.workingDir[self.args[2]]
        if not src then
            Terminal:endProg(-1, "NO SUCH FILE OR DIRECTORY")
        elseif not dest then
            Terminal.workingDir[self.args[2]] = src
            Terminal.workingDir[self.args[1]] = nil
            Terminal:endProg()
        elseif type(dest) ~= "table" then
            Terminal:endProg(-1, "CANNOT OVERWRITE NON-DIRECTORY")
        else
            Terminal.workingDir[self.args[2]][self.args[1]] = src
            Terminal.workingDir[self.args[1]] = nil
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
