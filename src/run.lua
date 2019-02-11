local program = { args = {} }
program.lines = {}
program.scriptArgs = {}
program.context = {}
program.returnVal = ""

function exec(inputStr)
    local s = {}
    for match in string.gmatch(inputStr, "%g+") do table.insert(s, match) end

    local cmd = s[1]
    local args = {}
    for i = 2, #s, 1 do args[#args + 1] = s[i] end
    Terminal:runProg(cmd, args)
end

function program:exec_line(line)
    if not line then return end

    local script, err = load(string.lower(line), nil, "t", self.context)
    if not script then
        Terminal:endProg(-1, "SYNTAX ERROR: " .. string.upper(err))
    else
        local ok, retVal = pcall(script, unpack(self.scriptArgs))
        if ok then
            returnVal = retVal
            if #self.lines == 0 then
                Terminal:endProg(0, string.upper(returnVal or ""))
            end
        else
            Terminal:clearQueue()
            Terminal:endProg(-1, "RUNTIME ERROR: " .. string.upper(retVal))
        end
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
            self.lines = {}
            self.context = {}
            self.context.exec = exec
            self.context.getoutput = function() return Terminal.returnStr end
            self.context.getexitcode = function() return Terminal.returnCode end
            self.context.string = string
            self.context.tonumber = tonumber
            self.context.ipairs = ipairs
            self.context.print = print

            self.scriptArgs = {}
            for i = 2, #self.args, 1 do self.scriptArgs[i - 1] = self.args[i] end

            for line in string.gmatch(file, "[^;]+;") do
                self.lines[#self.lines + 1] = string.sub(line, 1, -2)
            end

            if #self.lines > 0 then
                self:exec_line(table.remove(self.lines, 1))
            else
                Terminal:endProg()
            end
        end
    end
end

function program:update(dt)
    if #self.lines > 0 then
        self:exec_line(table.remove(self.lines, 1))
    else
        Terminal:endProg(0, string.upper(returnVal or ""))
    end
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end
function program:draw() end
function program:keypressed(key) end
function program:textinput(key) end

return program
