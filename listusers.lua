local program = { args = {} }

function program:onEnter()
    local strBuf = { "LIST OF USERS\n-------------" }
    for _, acc in pairs(Systems[Terminal.ip].accounts) do strBuf[#strBuf + 1] = acc.username end
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
