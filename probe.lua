local program = { args = {} }

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "PROBE REQUIRES 1 PARAMETER: <IP>")
    elseif not Systems[self.args[1]] then
        Terminal:endProg(-1, "NO SYSTEM WITH IP: " .. self.args[1])
    elseif Systems[self.args[1]].online ~= "true" then
        Terminal:endProg(-1, "SYSTEM IS OFFLINE")
    else
        local strBuf = { "LIST OF INFORMATION\n-------------------" }
        local sys = Systems[self.args[1]]
        strBuf[#strBuf + 1] = "\n"
        strBuf[#strBuf + 1] = "NAME: "
        strBuf[#strBuf + 1] = sys.name
        strBuf[#strBuf + 1] = "\n"
        strBuf[#strBuf + 1] = "OWNER: "
        strBuf[#strBuf + 1] = sys.owner
        strBuf[#strBuf + 1] = "\n"
        strBuf[#strBuf + 1] = "IP-ADDRESS: "
        strBuf[#strBuf + 1] = self.args[1]
        strBuf[#strBuf + 1] = "\n"
        strBuf[#strBuf + 1] = "NEIGHBOURS: "
        strBuf[#strBuf + 1] = #sys.neighbours
        strBuf[#strBuf + 1] = "\n"
        strBuf[#strBuf + 1] = "FIREWALL: "
        strBuf[#strBuf + 1] = (sys.firewall > 0 and sys.firewall .. "%" or "NO")
        strBuf[#strBuf + 1] = "\n"
        strBuf[#strBuf + 1] = "IDS: "
        if sys.ids > 0 and CC:hasProcessWithName(self.args[1], "IDS") then
            strBuf[#strBuf + 1] = sys.ids .. " SECONDS"
        else
            strBuf[#strBuf + 1] = "NONE"
        end

        CC:addSystem(self.args[1])
        Terminal:endProg(0, table.concat(strBuf))
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
