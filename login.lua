local program = { args = {} }

local Fonts = Fonts
local ERROR_TIME = 2
local blinkTimer = 0
local errorTimer = 0
local cursorVisible = false
local authFailed = false
local sysOffline = false
local usernameEntered = false

local cmd = ""
local cursor = "_"
local username = ""
local passwd = ""

function program:reset()
    blinkTimer = 0
    errorTimer = 0
    cursorVisible = false
    authFailed = false
    sysOffline = false
    usernameEntered = false
    cmd = ""
    username = ""
    passwd = ""
    Terminal.ip = "192.168.1.1"
end

function program:onEnter()
    self:reset()
end

function program:onResume()
    self:reset()
end

function program:update(dt)
    blinkTimer = blinkTimer + dt
    if blinkTimer > BLINK_TIME then
        blinkTimer = 0
        cursorVisible = not cursorVisible
    end

    if authFailed or sysOffline then errorTimer = errorTimer + dt end
    if errorTimer > ERROR_TIME then
        errorTimer = 0
        authFailed = false
        sysOffline = false
    end

end

function program:draw()
    love.graphics.setFont(Fonts["bold-16"])
    love.graphics.setColor(255, 255, 255)
    if authFailed then
        love.graphics.printf("** INCORRECT LOGIN, ACCESS DENIED **", 0, 66, love.graphics.getWidth(), "center")
    elseif sysOffline then
        love.graphics.printf("** SYSTEM OFFLINE **", 0, 66, love.graphics.getWidth(), "center")
    else
        if usernameEntered then
            love.graphics.print("LOGIN: " .. username, 16, 16)
            love.graphics.print("PASSWORD: " .. cmd .. (cursorVisible and cursor or ""), 16, 40)
        else
            love.graphics.print("LOGIN: " .. cmd .. (cursorVisible and cursor or ""), 16, 16)
        end
    end
end

function program:keypressed(key)
    if authFailed or sysOffline then return end

    if key == "backspace" then
        cmd = cmd:sub(1, -2)
        passwd = passwd:sub(1, -2)
    elseif key == "escape" then
        Screens:setScreen("mainmenu")
    elseif key == "return" then
        if usernameEntered then
            local sys = Systems[Terminal.rootIp]
            local acc = sys and sys.accounts[username] or nil

            if not acc or acc.passwd ~= passwd or username ~= Terminal.rootUsername then
                authFailed = true
            elseif sys.online ~= "true" then
                sysOffline = true
            else
                Terminal.username = username
                Terminal.workingDir = Systems[Terminal.ip].fs
                Terminal.workingDirPath = "/"
                Terminal:runProg("root")
            end
            username = ""
            passwd = ""
            usernameEntered = false
        else
            username = cmd
            usernameEntered = true
        end
        cmd = ""
    end
end

function program:textinput(key)
    if authFailed or sysOffline then return end
    cmd = cmd .. (usernameEntered and "*" or string.upper(key))
    passwd = usernameEntered and passwd .. string.upper(key) or ""
end

-- Unused
function program:onExit() end
function program:onPause() end

return program
