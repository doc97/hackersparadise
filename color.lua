local program = { args = {} }

function program:onEnter()
    if #self.args == 0 then
        local c = Systems[Terminal.ip].color
        Terminal:endProg(0, "CURRENT COLOR IS (" .. c[1] .. ", " .. c[2] .. ", " .. c[3] .. ")")
    elseif #self.args < 3 then
        Terminal:endProg(-1, "COLOR REQUIRES 3 PARAMETERS: <R> <G> <B>\n   OR 0 PARAMETERS TO VIEW CURRENT COLOR")
    else
        local c = Systems[Terminal.ip].color
        c[1] = tonumber(self.args[1]) or c[1]
        c[2] = tonumber(self.args[2]) or c[2]
        c[3] = tonumber(self.args[3]) or c[3]
        Terminal:endProg(0, "COLOR CHANGED TO (" .. c[1] .. ", " .. c[2] .. ", " .. c[3] .. ")")
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
