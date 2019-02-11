local program = { args = {} }

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "START REQUIRES 1 PARAMETER: <PROCESS NAME>")
    elseif CC:hasProcessWithName(Terminal.ip, self.args[1]) then
        Terminal:endProg(-1, "PROCESS WITH THAT NAME ALREADY EXISTS")
    else
        CC:startProcess(Terminal.ip, self.args[1])
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
