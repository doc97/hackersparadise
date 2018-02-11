local program = { args = {} }
local Fonts = Fonts

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "CANNOT ADD AN EMPTY NOTE")
    else
        local formattedStr = {}
        local s = table.concat(self.args, " ")
        local len = Fonts["bold-12"]:getWidth(s)
        local subLen = len
        local diff = string.len(s)
        local i = diff
        local epsilon = 20

        while diff > 1 do--math.abs(250 - subLen) > epsilon do
            if subLen < 220 then i = math.ceil(i + diff / 2)
            else i = math.ceil(i - diff / 2) end
            diff = math.ceil(diff / 2)

            subLen = Fonts["bold-12"]:getWidth(string.sub(s, 1, i))
        end
        formattedStr[#formattedStr + 1] = string.sub(s, 1, i)
        if i < string.len(s) then formattedStr[#formattedStr + 1] = string.sub(s, i + 1) end

        local notes = Systems[Terminal.rootIp].notes
        notes[#notes + 1] = table.concat(formattedStr, "\n")
        Terminal:endProg(0, "NOTE ADDED")
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
