local program = { args = {} }

function program:onEnter()
    local Settings = Settings
    if #self.args == 0 then
        local buf = {}
        for alias,actual in pairs(Settings.aliases) do buf[#buf + 1] = "'" .. alias .. "' -> '" .. actual .. "'" end
        Terminal:endProg(0, table.concat(buf, "\n"))
    elseif #self.args == 1 then
        local alias = Settings.aliases[self.args[1]]
        if alias then
            Terminal:endProg(0, "ALIAS FOR '" .. self.args[1] .. "' IS '" .. alias .. "'")
        else
            Terminal:endProg(0, "NO ALIAS SET FOR '" .. self.args[1] .. "'")
        end
    else
        local actual = {}
        for i = 2, #self.args, 1 do actual[i - 1] = self.args[i] end
        Settings.aliases[self.args[1]] = table.concat(actual)
        Terminal:endProg()
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
