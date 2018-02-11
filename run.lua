local program = { args = {} }

local cmds = {}
local args = {}

function program:nextProg()
    if #cmds == 0 then
        Terminal:endProg(0, Terminal.returnStr .. "\nSCRIPT FINISHED")
    else
        local cmd = table.remove(cmds, 1)
        local arg = table.remove(args, 1)
        Terminal:runProg(string.lower(cmd), arg)
    end
end

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "RUN REQUIRES 1 PARAMETER: <SCRIPT>")
    else
        local file = getFile(Terminal.ip, Terminal.workingDirPath, self.args[1])
        if not file then
            Terminal:endProg(-1, "NO SUCH FILE EXISTS")
        else
            for line in string.gmatch(file, "[^\n]+") do
                local s = {}
                for word in string.gmatch(line, "%g+") do s[#s + 1] = word end
                cmds[#cmds + 1] = s[1]
                table.remove(s, 1)
                args[#args + 1] = s
            end

            if #cmds == 0 then
                Terminal:endProg(0, "")
            else
                self:nextProg()
            end
        end
    end
end

function program:onResume()
    if Terminal.returnCode ~= 0 then
        Terminal:endProg(-1, Terminal.returnStr .. "\n--\nSCRIPT ABORTED!")
    else
        self:nextProg()
    end
end

-- Unused
function program:onExit() end
function program:onPause() end
function program:update(dt) end
function program:draw() end
function program:keypressed(key) end
function program:textinput(key) end

return program
