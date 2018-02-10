local program = { args = {} }

local HELP_MSG = [[
ADDUSER - INTERACTIVELY ADD A USER
ADDNOTE - ADD A NOTE
CD - CHANGE DIRECTORY
CLEAR - CLEAR OUTPUT BUFFER
COLOR - SHOW OR SET SYSTEM COLOR
CONNECT - CONNECT TO SYSTEM
CP - COPY FILE OR DIRECTORY
DELUSER - DELETE A USER
DELNOTE - DELETE A NOTE
DISCONNECT - DISCONNECT FROM CURRENT SYSTEM
EDIT - EDIT A FILE
EXIT - EXIT TERMINAL SESSION (THE GAME)
HACK - ATTACKS A PORT ON A TARGET SYSTEM
HELP - SHOWS THIS HELP
KILL - KILL A PROCESS
LISTUSERS - LIST USERS ON THE SYSTEMS
LS - LIST CURRENT DIRECTORY
MAIL - VIEW MAIL INBOX
MAN - OPENS THE MANUAL
MKDIR - MAKE NEW DIRECTORY
MV - MOVE FILE OR DIRECTORY
NOTES - TOGGLE SHOWING NOTES
LOGOUT - LOG OUT (RETURN TO MAIN MENU)
PASSWD - CHANGE PASSWORD ON THE SYSTEM
PROBE - GATHER INFORMATION ABOUT SYSTEM
PS - LIST PROCESSES
READ - READ THE CONTENTS OF A FILE
RM - REMOVE FILE OR DIRECTORY
SCAN - SCAN A SYSTEM FOR OPEN PORTS
SEARCH - SEARCH FOR NEIGHBOURING SYSTEMS
START - START A PROCESS
WHOAMI - SHOWS THE CURRENT USERNAME
]]
local blinkTimer = 0
local cursorVisible = false;

local cmdStack = {}
local cmdIndex = 1
local input = {}
local inputStr = ""
local inputDirty = false
local output = {}
local cursor = "_"
local pageCount = 0
local pageRows = 20
local page = 1

function program:setOutput(str)
    output = {}
    pageCount = 0
    for s in string.gmatch(str, "[^\n]+") do
        output[#output + 1] = s
    end
    pageCount = math.ceil(#output / pageRows)
    page = #output > 0 and 1 or 0
end

function program:reset()
    cursorVisble = false
    blinkTimer = 0
    input = {}
    inputStr = ""
    inputDirty = false
    output = {}
    pageCount = 0
    page = 0
end

function program:onEnter()
    cmdStack = {}
    self:reset()
end

function program:onResume()
    self:reset()
    self:setOutput(Terminal.returnStr)
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
    love.graphics.setColor(Systems[Terminal.ip].color)
    love.graphics.printf("-== PROPERTY OF " .. Systems[Terminal.ip].owner .. " ==-", 0, 16, love.graphics.getWidth(), "center")
    love.graphics.print(Terminal.username .. "@" .. Terminal.ip .. ":" .. Terminal.workingDirPath .. "> " .. inputStr .. (cursorVisible and cursor or ""), 16, 40)

    -- Paged output
    if pageCount > 1 then
        love.graphics.printf(page .. "/" .. pageCount, -16, love.graphics.getHeight() - 32, love.graphics.getWidth(), "right")
    end
    for i = 1, pageRows, 1 do
        local index = (page - 1) * pageRows + i
        if index < 1 or index > #output then break end
        love.graphics.print(output[index], 16, 88 + (i - 1) * 24)
    end

    -- IDS Tracking
    local idsIp = CC:isBeingDetected(Terminal.rootIp)
    if idsIp then
        love.graphics.printf("TIME UNTIL DETECTION: " .. string.format("%.1f", Systems[idsIp].ids - CC.ids[idsIp].timer) .. " SECONDS!",
        0, love.graphics.getHeight() - 64, love.graphics.getWidth(), "center")
    end

    -- Notes
    if Settings.showNotes ~= "false" then
        local color = { }
        for i = 0, #Systems[Terminal.ip].color, 1 do color[i] = Systems[Terminal.ip].color[i] end
        color[4] = 50
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 266, 88, 250, love.graphics.getHeight() - 128) 
        love.graphics.setColor(Systems[Terminal.ip].color)
        love.graphics.print("NOTES", love.graphics.getWidth() - 258, 96)

        love.graphics.setFont(Fonts["bold-12"])
        local y = 120
        for i,note in ipairs(Systems[Terminal.rootIp].notes) do
            local str = i .. ": " .. note
            local rows = 1
            for match in string.gmatch(str, "\n") do rows = rows + 1 end
            love.graphics.print(str, love.graphics.getWidth() - 258, y)
            y = y + rows * 12 * 1.5
        end
        love.graphics.setFont(Fonts["bold-16"])
    end
end

function program:keypressed(key)
    if key == "backspace" then
        input[#input] = nil
        inputDirty = true
    elseif key == "right" then
        page = (page + 1)
        if page > pageCount then page = 1 end
    elseif key == "left" then
        if pageCount > 0 then
            page = (page - 1) % pageCount
            if page < 1 then page = pageCount end
        end
    elseif key == "up" then
        if cmdIndex < #cmdStack then
            cmdIndex = cmdIndex + 1
            local cmdStr = cmdStack[cmdIndex]
            input = {}
            for char in string.gmatch(cmdStr, ".") do input[#input + 1] = char end
            inputDirty = true
        end
    elseif key == "down" then
        if cmdIndex > 0 then
            cmdIndex = cmdIndex - 1
            local cmdStr = cmdIndex > 0 and cmdStack[cmdIndex] or ""
            input = {}
            for char in string.gmatch(cmdStr, ".") do input[#input + 1] = char end
            inputDirty = true
        end
    elseif key == "return" then
        output = {}
        local s = {}
        for match in string.gmatch(table.concat(input), "%g+") do table.insert(s, match) end

        local cmd = s[1]
        local args = {}
        for i = 2, #s, 1 do args[i - 1] = s[i] end

        table.insert(cmdStack, 1, table.concat(input))
        if #cmdStack > 10 then cmdStack[#cmdStack] = nil end
        cmdIndex = 0

        if cmd == "ADDUSER" then Terminal:runProg("adduser")
        elseif cmd == "ADDNOTE" then Terminal:runProg("addnote", args)
        elseif cmd == "CD" then Terminal:runProg("cd", args)
        elseif cmd == "CLEAR" then self:setOutput("")
        elseif cmd == "COLOR" then Terminal:runProg("color", args)
        elseif cmd == "CONNECT" then Terminal:runProg("connect", args)
        elseif cmd == "CP" then Terminal:runProg("cp", args)
        elseif cmd == "DELUSER" then Terminal:runProg("deluser", args)
        elseif cmd == "DELNOTE" then Terminal:runProg("delnote", args)
        elseif cmd == "DISCONNECT" then Terminal:runProg("disconnect")
        elseif cmd == "EDIT" then Terminal:runProg("edit", args)
        elseif cmd == "EXIT" then love.event.quit()
        elseif cmd == "HACK" then Terminal:runProg("hack", args)
        elseif cmd == "HELP" then self:setOutput(HELP_MSG)
        elseif cmd == "KILL" then Terminal:runProg("kill", args)
        elseif cmd == "LISTUSERS" then Terminal:runProg("listusers")
        elseif cmd == "LS" then Terminal:runProg("ls", args)
        elseif cmd == "LOGOUT" then Terminal:endProg()
        elseif cmd == "MAIL" then Terminal:runProg("mail")
        elseif cmd == "MAN" then Screens:setScreen("manual")
        elseif cmd == "MKDIR" then Terminal:runProg("mkdir", args)
        elseif cmd == "MV" then Terminal:runProg("mv", args)
        elseif cmd == "NOTES" then Terminal:runProg("notes")
        elseif cmd == "PASSWD" then Terminal:runProg("passwd")
        elseif cmd == "PROBE" then Terminal:runProg("probe", args)
        elseif cmd == "PS" then Terminal:runProg("ps")
        elseif cmd == "PWD" then self:setOutput(Terminal.workingDirPath)
        elseif cmd == "READ" then Terminal:runProg("read", args)
        elseif cmd == "RM" then Terminal:runProg("rm", args)
        elseif cmd == "SCAN" then Terminal:runProg("scan", args)
        elseif cmd == "SEARCH" then Terminal:runProg("search")
        elseif cmd == "START" then Terminal:runProg("start", args)
        elseif cmd == "WHOAMI" then self:setOutput(Terminal.username)
        else self:setOutput((cmd or "") .. ": COMMAND NOT FOUND")
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
function program:onPause() end

return program
