local program = { args = {} }

function program:onEnter()
    local username = ""
    if #self.args > 0 then
        username = self.args[1]
    end
    if not Systems[Terminal.ip].accounts[username] then
        Terminal:endProg(-1, "NO ACCOUNT FOUND")
    elseif username == Terminal.username then
        Terminal:endProg(-1, "CANNOT DELETE CURRENT USER")
    else
        Systems[Terminal.ip].accounts[username] = nil
        Terminal:endProg(0, "DELETED USER '" .. username .. "'")
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
