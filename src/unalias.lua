local program = { args = {} }

function program:onEnter()
    if #self.args == 0 then
        Terminal:endProg(-1, "UNALIAS REQUIRES 1 PARAMETER: <ALIAS NAME>")
    else
        local alias = Settings.aliases[self.args[1]]
        if not alias then
            Terminal:endProg(-1, "NO ALIAS SET FOR " .. self.args[1])
        else
            Settings.aliases[self.args[1]] = nil
            Terminal:endProg(0, "REMOVED ALIAS '" .. self.args[1] .. "'")
        end
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
