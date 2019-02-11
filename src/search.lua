local program = { args = {} }

function program:onEnter()
    local strBuf = { "LIST OF NEIGHBOURS\n------------------" }
    for _, ip in ipairs(Systems[Terminal.ip].neighbours) do
        strBuf[#strBuf + 1] = "\n"
        strBuf[#strBuf + 1] = ip
        if Systems[ip].online ~= "true" then strBuf[#strBuf + 1] = " - OFFLINE" end
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
