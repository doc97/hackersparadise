local program = { args = {} }

function program:onEnter()
    local strBuf = { "LIST OF KNOWN SYSTEMS\n-------------------" }
    for sys,_ in pairs(PlayerInfo.knownSystems) do strBuf[#strBuf + 1] = sys end
    Terminal:endProg(0, table.concat(strBuf, "\n"))
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
