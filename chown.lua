local program = { args = {} }

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "CHOWN REQUIRES 1 PARAMETER: <NAME>")
    else
        Systems[Terminal.ip].owner = self.args[1]
        Terminal:endProg(0, "CHANGED SYSTEM OWNER TO " .. self.args[1])
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
