local program = { args = {} }

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "KILL REQUIRES 1 PARAMETER: <PID>")
    elseif not tonumber(self.args[1]) then
        Terminal:endProg(-1, "PID MUST BE A NUMBER")
    elseif not CC:killProcess(Terminal.ip, tonumber(self.args[1])) then
        Terminal:endProg(-1, "NO PROCESS WITH THAT PID")
    else
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
