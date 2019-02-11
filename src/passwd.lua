local program = { args = {} }

local attempts = 0
local authenticated = false
local input = {}
local inputStr = ""
local inputDirty = false
local output = ""

function program:onEnter()
    attempts = 0
    authenticated = false
    input = {}
    inputStr = ""
    inputDirty = false
    output = "ENTER CURRENT PASSWORD: "
end

function program:update(dt)
    if inputDirty then
        inputStr = string.rep("*", #input)
        inputDirty = false
    end
end

function program:draw()
    Terminal:drawBanner()
    love.graphics.print(output .. inputStr, 16, 40)
end

function program:keypressed(key)
    if key == "backspace" then
        input[#input] = nil
        inputDirty = true
    elseif key == "return" then
        if not authenticated then
            attempts = attempts + 1

            if Systems[Terminal.ip].accounts[Terminal.username].passwd == table.concat(input) then
                authenticated = true
                output = output .. "\nENTER NEW PASSWORD: "
            elseif attempts < 3 then
                output = output .. "\nSORRY, TRY AGAIN.\n\nENTER CURRENT PASSWORD: "
            else
                Terminal.returnCode = -1
                Terminal.returnStr = "Program exited with code -1"
                Terminal:endProg()
            end
        else
            Systems[Terminal.ip].accounts[Terminal.username].passwd = table.concat(input)
            Terminal.returnCode = 0
            Terminal.returnStr = "SUCCESS."
            Terminal:endProg()
        end
        input = {}
        inputDirty = true
    end
end

function program:textinput(key)
    input[#input + 1] = string.upper(key)
    inputDirty = true
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end

return program
