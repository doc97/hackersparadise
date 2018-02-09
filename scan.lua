local program = { args = {} }

function program:onEnter()
    local output = ""
    if #self.args < 1 then
        Terminal:endProg(-1, "SCAN REQUIRES 1 PARAMETER: <IP>")
    elseif not Systems[self.args[1]] then
        Terminal:endProg(-1, "COULD NOT SCAN SYSTEM AT IP: " .. self.args[1])
    else
        local strBuf = { "LIST OF PORTS\n-------------" }
        for key, value in pairs(Systems[self.args[1]].ports) do
            strBuf[#strBuf + 1] = "\n"
            strBuf[#strBuf + 1] = key
            strBuf[#strBuf + 1] = " (" 
            strBuf[#strBuf + 1] = value.service
            strBuf[#strBuf + 1] = "): "
            strBuf[#strBuf + 1] = value.status
        end
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
