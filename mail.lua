local program = { args = {} }

local inboxInstructions = " [ENTER] READ MAIL    [UP]/[DOWN] NAVIGATE    [TAB] RETURN"
local msgInstructions = " [ENTER] RETURN TO INBOX"
local inboxTitle = "MAIL INBOX\n-------------\n"
local msgTitle = ""
local outBuf = {}
local selection = 1
local fontHeight = 32
local contents = {}
local subjects = {}
local readMode = false

function program:onEnter()
    readMode = false
    count = 0
    selection = 1
    outBuf = {}
    contents = {}

    for i,mail in ipairs(Systems[Terminal.rootIp].mail) do
        local strBuf = { }
        strBuf[#strBuf + 1] = i
        strBuf[#strBuf + 1] = ": "
        strBuf[#strBuf + 1] = mail["subject"]
        strBuf[#strBuf + 1] = " (FROM: "
        strBuf[#strBuf + 1] = mail["sender"]
        strBuf[#strBuf + 1] = ")"
        strBuf[#strBuf + 1] = "\n"
        outBuf[#outBuf + 1] = table.concat(strBuf)
        contents[#contents + 1] = mail["message"]
        subjects[#subjects + 1] = mail["subject"] .. "\n-------------"
    end
end

function program:update(dt)
end

function program:draw()
    if readMode then
        love.graphics.print(subjects[selection], 32, 32)
        love.graphics.print(contents[selection], 32, 32 + 24 * 2)
        love.graphics.rectangle("fill", 30, love.graphics.getHeight() - fontHeight, love.graphics.getWidth() - 60, 24)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(msgInstructions, 32, love.graphics.getHeight() - fontHeight)
        love.graphics.setColor(Systems[Terminal.ip].color)
    else
        if #outBuf > 0 then
            love.graphics.rectangle("fill", 30, 32 + 24 * 2 + (selection - 1) * fontHeight, love.graphics.getWidth() - 60, 24)
        end

        love.graphics.print(inboxTitle, 32, 32)
        for i,s in ipairs(outBuf) do
            if selection == i then
                love.graphics.setColor(0, 0, 0)
            end
            love.graphics.print(s, 32, 32 + 24 * 2 + (i - 1) * fontHeight)
            love.graphics.setColor(Systems[Terminal.ip].color)
        end

        love.graphics.rectangle("fill", 30, love.graphics.getHeight() - fontHeight, love.graphics.getWidth() - 60, 24)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(inboxInstructions, 32, love.graphics.getHeight() - fontHeight)
        love.graphics.setColor(Systems[Terminal.ip].color)
    end
end

function program:keypressed(key)
    if key == "return" then
        readMode = not readMode
    end

    if not readMode then
        if key == "tab" then
            Terminal:endProg(0)
        elseif key == "up" and selection > 1 then
            selection = selection - 1
        elseif key == "down" and selection < #outBuf then
            selection = selection + 1
        end
    end
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end
function program:textinput(key) end

return program
