local program = { args = {} }

local input = {}
local inputStr = ""
local inputDirty = false
local output = ""
local cursor = "_"
local username = nil
local blinkTimer = 0
local cursorVisible = false

function program:onEnter()
    input = {}
    inputStr = ""
    inputDirty = false
    output = "ENTER USERNAME: "
    username = nil
    cursorVisible = false
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
end

function program:draw()
    Terminal:drawBanner()
    love.graphics.print(output .. inputStr .. (cursorVisible and cursor or ""), 16, 40)
end

function program:keypressed(key)
    if key == "backspace" then
        input[#input] = nil
        inputDirty = true
    elseif key == "return" then
        local inputStr = table.concat(input)
        if username then
            Systems[Terminal.ip].accounts[username] = { ["username"] = username, ["passwd"] = inputStr }
            Terminal:endProg(0, "USER '" .. username .. "' ADDED")
        elseif Systems[Terminal.ip].accounts[inputStr] then
            output = output .. "\nA USER WITH THAT NAME ALREADY EXISTS\n\nENTER USERNAME: "
        else
            username = inputStr
            output = output .. "\nENTER PASSWORD: "
        end
        input = {}
        inputDirty = true
    end
end

function program:textinput(key)
    if not username and key == " " then return end
    input[#input + 1] = string.upper(key)
    inputDirty = true
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end

return program
