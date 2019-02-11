local program = { args = {} }

local HELP_MSG = [[
ADDUSER - INTERACTIVELY ADD A USER
ADDNOTE - ADD A NOTE
ALIAS - CREATE AN ALIAS FOR A STRING
CD - CHANGE DIRECTORY
CHOWN - CHANGE OWNER
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
LISTSYS - LIST SYSTEMS YOU HAVE DISCOVERED
LOGOUT - LOG OUT (RETURN TO MAIN MENU)
LS - LIST CURRENT DIRECTORY
MAIL - VIEW MAIL INBOX
MAN - OPENS THE MANUAL
MKDIR - MAKE NEW DIRECTORY
MV - MOVE FILE OR DIRECTORY
NOTES - TOGGLE SHOWING NOTES
PASSWD - CHANGE PASSWORD ON THE SYSTEM
PROBE - GATHER INFORMATION ABOUT SYSTEM
PS - LIST PROCESSES
READ - READ THE CONTENTS OF A FILE
RM - REMOVE FILE OR DIRECTORY
ROUTE - ROUTE TRAFFIC THROUGH A PROXY
RUN - RUN A SCRIPT
SCAN - SCAN A SYSTEM FOR OPEN PORTS
SCP - SECURE COPY FILES TO ROOT SYSTEM
SEARCH - SEARCH FOR NEIGHBOURING SYSTEMS
START - START A PROCESS
TRACEROUTE - TRACE CURRENT ROUTE OF TRAFFIC
UNALIAS - REMOVE AN ALIAS
WHOAMI - SHOWS THE CURRENT USERNAME
]]
local navInstructions = " [TAB] SCROLL     [UP]/[DOWN] NEXT/PREV CMD     [LEFT]/[RIGHT] MOVE CURSOR"
local blinkTimer = 0
local cursorVisible = false;

local cmdStack = {}
local cmdIndex = 1
local input = {}
local inputStr = ""
local inputDirty = false
local output = {}
local cursor = "_"
local cursorPos = 1
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
    cursorPos = 1
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
    Terminal:drawBanner()

    local prompt = Terminal.username .. "@" .. Terminal.ip .. ":" .. Terminal.workingDirPath .. "> "
    local cmdStr1 = string.sub(inputStr, 1, cursorPos - 1)
    local cmdStr2 = string.sub(inputStr, cursorPos)
    local cmdStr = cmdStr1 .. (cursorVisible and cursor or " ") .. cmdStr2
    love.graphics.print(prompt .. cmdStr, 16, 40)

    -- Paged output
    for i = 1, pageRows, 1 do
        local index = (page - 1) * pageRows + i
        if index < 1 or index > #output then break end
        love.graphics.print(output[index], 16, 88 + (i - 1) * 24)
    end

    -- IDS Tracking
    local idsIp = CC:isBeingDetectedBy(Terminal.ip)
    if idsIp then
        love.graphics.printf("TIME UNTIL DETECTION: " .. string.format("%.1f", CC.ids[idsIp].timer) .. " SECONDS!",
        0, love.graphics.getHeight() - 64, love.graphics.getWidth(), "center")
    end

    -- Notes
    if Settings.showNotes ~= "false" then
        local color = { }
        for i = 0, #Systems[Terminal.ip].color, 1 do color[i] = Systems[Terminal.ip].color[i] end
        color[4] = 50
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", love.graphics.getWidth() - 266, 88, 250, love.graphics.getHeight() - 160) 
        love.graphics.setColor(Systems[Terminal.ip].color)
        love.graphics.print("NOTES", love.graphics.getWidth() - 258, 96)

        love.graphics.setFont(Fonts["bold-12"])
        local y = 120
        for i,note in ipairs(PlayerInfo.notes) do
            local str = i .. ": " .. note
            local rows = 1
            for match in string.gmatch(str, "\n") do rows = rows + 1 end
            love.graphics.print(str, love.graphics.getWidth() - 258, y)
            y = y + rows * 12 * 1.5
        end
    end

    -- Page number
    if pageCount > 1 then
        love.graphics.setFont(Fonts["bold-16"])
        love.graphics.printf(page .. "/" .. pageCount, -32, love.graphics.getHeight() - 64, love.graphics.getWidth(), "right")
    end

    -- Navigation bar
    love.graphics.setFont(Fonts["bold-16"])
    love.graphics.rectangle("fill", 14, love.graphics.getHeight() - 32, love.graphics.getWidth() - 28, 24)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(navInstructions, 32, love.graphics.getHeight() - 32)
    love.graphics.setColor(Systems[Terminal.ip].color)

    Terminal:drawTutorialMessage()
end

function program:keypressed(key)
    if key == "backspace" then
        table.remove(input, cursorPos - 1)
        if cursorPos > 1 then cursorPos = cursorPos - 1 end
        inputDirty = true
    elseif key == "tab" then
        page = (page + 1)
        if page > pageCount then page = 1 end
    elseif key == "left" then
        if cursorPos > 1 then cursorPos = cursorPos - 1 end
    elseif key == "right" then
        if cursorPos <= #input then cursorPos = cursorPos + 1 end
    elseif key == "up" then
        if cmdIndex < #cmdStack then
            cmdIndex = cmdIndex + 1
            local cmdStr = cmdStack[cmdIndex]
            input = {}
            for char in string.gmatch(cmdStr, ".") do input[#input + 1] = char end
            inputDirty = true
            cursorPos = #input + 1
        end
    elseif key == "down" then
        if cmdIndex > 0 then
            cmdIndex = cmdIndex - 1
            local cmdStr = cmdIndex > 0 and cmdStack[cmdIndex] or ""
            input = {}
            for char in string.gmatch(cmdStr, ".") do input[#input + 1] = char end
            inputDirty = true
            cursorPos = #input + 1
        end
    elseif key == "return" then
        output = {}
        local s = {}
        for match in string.gmatch(table.concat(input), "%g+") do table.insert(s, match) end

        local cmd = s[1]
        local args = {}
        for i = 2, #s, 1 do args[#args + 1] = s[i] end
        
        if cmd then
            table.insert(cmdStack, 1, table.concat(input))
            if #cmdStack > 10 then cmdStack[#cmdStack] = nil end
            cmdIndex = 0
        end

        if cmd == "CLEAR" then self:setOutput("")
        elseif cmd == "EXIT" then love.event.quit()
        elseif cmd == "HELP" then self:setOutput(HELP_MSG)
        elseif cmd == "LOGOUT" then Terminal:endProg()
        elseif cmd == "MAN" then Screens:setScreen("manual")
        elseif not cmd or not Terminal:runProg(string.lower(cmd), args) then
            self:setOutput((cmd or "") .. ": COMMAND NOT FOUND")
        end

        input = {}
        inputDirty = true
        cursorPos = #input + 1
    end
end

function program:textinput(key)
	if #key > 1 then return end
    table.insert(input, cursorPos, string.upper(key))
    cursorPos = cursorPos + 1
    inputDirty = true
end

-- Unused
function program:onExit() end
function program:onPause() end

return program
