local program = { args = {} }

local CONNECTION_TIME = 3
local connectionTimer = 0

local input = {}
local inputStr = ""
local inputDirty = false
local output = ""
local cursor = "_"
local ip = ""
local username = nil
local passwd = ""
local blinkTimer = 0
local cursorVisible = false
local connecting = false

function program:onEnter()
    if #self.args < 1 then
        Terminal:endProg(-1, "CONNECT REQUIRES 1 PARAMETER: <IP>")
    elseif not Systems[self.args[1]] then
        Terminal:endProg(-1, "NO SYSTEM WITH IP: " .. self.args[1])
    elseif Systems[self.args[1]].online ~= "true" then
        Terminal:endProg(-1, "SYSTEM IS OFFLINE")
    elseif Terminal.ip == self.args[1] then
        Terminal:endProg(-1, "ALREADY CONNECTED")
    else
        input = {}
        inputStr = ""
        inputDirty = false
        output = "ENTER USERNAME: "
        ip = self.args[1]
        username = nil
        passwd = ""
        connectionTimer = 0
        cursorVisible = false
        connecting = false
    end
end

function program:update(dt)
    blinkTimer = blinkTimer + dt
    if blinkTimer > BLINK_TIME then
        blinkTimer = 0
        cursorVisible = not cursorVisible
    end

    if inputDirty then
        inputStr = table.concat(input)
        inputDirty = false
    end

    if connecting then connectionTimer = connectionTimer + dt end
    if connectionTimer > CONNECTION_TIME then
        connectionTimer = 0
        Terminal.ip = ip
        Terminal.username = username
        Terminal.workingDir = Systems[Terminal.ip].fs
        Terminal.workingDirPath = "/"
        Terminal:endProg()
    end
end

function program:draw()
    love.graphics.setColor(Systems[Terminal.ip].color)
    Terminal:drawBanner()
    if connecting then
        love.graphics.print("CONNECTING TO " .. self.args[1] .. "...", 16, 64)
    else
        love.graphics.print(output .. inputStr .. (cursorVisible and cursor or ""), 16, 40)
    end
end

function program:keypressed(key)
    if connecting then return end

    if key == "backspace" then
        input[#input] = nil
        inputDirty = true
        passwd = passwd:sub(1, -2)
    elseif key == "return" then
        local inputStr = table.concat(input)
        if username then
            if Systems[ip].accounts[username] and Systems[ip].accounts[username].passwd == passwd then
                connecting = true
            else
                Terminal:endProg(-1, "AUTHENTICATION FAILED")
            end
        else
            username = inputStr
            output = output .. username .. "\nENTER PASSWORD: "
        end
        input = {}
        inputDirty = true
    end
end

function program:textinput(key)
    if connecting then return end
    if username then
        passwd = passwd .. string.upper(key)
        input[#input + 1] = "*"
    else
        input[#input + 1] = string.upper(key)
    end
    inputDirty = true
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end

return program
