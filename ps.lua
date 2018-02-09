local program = { args = {} }

function program:onEnter()
    local strBuf = { "PID    NAME\n----    ----" }
    for pid, name in pairs(Systems[Terminal.ip].processes) do
        strBuf[#strBuf + 1] = "\n"
        if #tostring(pid) == 1 then strBuf[#strBuf + 1] = "   "
        elseif #tostring(pid) == 2 then strBuf[#strBuf + 1] = "  " end
        strBuf[#strBuf + 1] = pid
        strBuf[#strBuf + 1] = "    "
        strBuf[#strBuf + 1] = name
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
