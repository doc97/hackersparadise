local program = { args = {} }

local Fonts = Fonts
local BLACK_TIME = 2
local printSpeed = 1/200
local blackTimer = 0
local printTimer = 0
local bootSeq = {}
local sequence = {}
local counter = 1
local rowCount = 25

function program:reset()
    counter = 1
    printTimer = 0
    blackTimer = 0
    sequence = {}
end

function program:onEnter()
    for line in love.filesystem.lines("assets/bootseq.txt") do
        table.insert(bootSeq, line)
    end

    rowCount = (love.graphics.getHeight() - 16) / 16
    self:reset()

    Terminal:runProg("login")
end

function program:onResume()
    self:reset()
end

function program:onPause()
end

function program:update(dt)
    if counter < #bootSeq then
        printTimer = printTimer + dt
    else
        blackTimer = blackTimer + dt
    end

    while printTimer > printSpeed do
        table.insert(sequence, bootSeq[counter])
        if #sequence > rowCount then table.remove(sequence, 1) end

        printTimer = printTimer - printSpeed
        counter = counter + 1

        printSpeed = (1200 - counter) * 0.000005
        if counter > 2 and counter % 400 < 2 then printSpeed = 1 end

        if counter >= #bootSeq then
            printTimer = 0
            break
        end
    end

    if blackTimer > BLACK_TIME then Terminal:runProg("login") end
end

function program:draw()
    if blackTimer == 0 then
        love.graphics.setFont(Fonts["reg-16"])
        for i = 1, #sequence, 1 do
            love.graphics.print(sequence[i], 16, 16 + (i - 1) * 16)
        end
    end
end

-- Unused
function program:onExit() end
function program:keypressed(key) end
function program:textinput(key) end

return program
