local program = { args = {} }

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "ROUTE REQUIRES 1 PARAMETER: <IP> OR 'RESET'")
    elseif self.args[1] == Terminal.ip or self.args[1] == "RESET" then
        Systems[Terminal.ip].route = ""
        Terminal:endProg(0, "ROUTE RESET")
    elseif not Systems[self.args[1]] then
        Terminal:endProg(-1, "NO SYSTEM WITH IP: " .. self.args[1])
    elseif Systems[Terminal.ip].owner ~= Systems[self.args[1]].owner then
        Terminal:endProg(-1, "YOU MUST OWN BOTH SYSTEMS YOU ARE ROUTING BETWEEN")
    else
        Systems[Terminal.ip].route = self.args[1]
        Terminal:endProg(0, "ROUTING TRAFFIC THROUGH " .. self.args[1])
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
