local program = { args = {} }

function program:onEnter()
    if Terminal.ip == Terminal.rootIp then
        Terminal.returnCode = -1
        Terminal.returnStr = "CANNOT DISCONNECT FROM ROOT NODE, DID YOU MEAN LOGOUT?"
    else
        CC:stopDetection(Terminal.rootIp, Terminal.ip)
        Terminal.returnCode = 0
        Terminal.returnStr = "DISCONNECTED FROM " .. Terminal.ip
        Terminal.ip = Terminal.rootIp
        Terminal.username = Terminal.rootUsername
        Terminal.workingDir = Systems[Terminal.ip].fs
        Terminal.workingDirPath = "/"
    end
    Terminal:endProg()
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
