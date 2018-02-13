local program = { args = {} }

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "DELNOTE REQUIRES 1 PARAMETER: <NOTE INDEX>")
    elseif not tonumber(self.args[1]) then
        Terminal:endProg(-1, "NOTE INDEX MUST BE A NUMBER")
    elseif tonumber(self.args[1]) < 1 or tonumber(self.args[1]) > #PlayerInfo.notes then
        Terminal:endProg(-1, "NO NOTE WITH INDEX: " .. self.args[1])
    else
        table.remove(PlayerInfo.notes, tonumber(self.args[1]))
        Terminal:endProg(0, "DELETED NOTE SUCCESSIVELY")
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
