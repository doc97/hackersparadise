local program = { args = {} }

local STEP_TIME = 0.2
local STEP_COUNT = 50
local stepTimer = 0
local step = 0
local ip = ""
local port = ""
local progressBar = "["

function program:onEnter()
    if #self.args < 2 then
        Terminal:endProg(-1, "HACK REQUIRES 2 PARAMETER: <IP> <PORT>")
    elseif not Systems[self.args[1]] then
        Terminal:endProg(-1, "COULD NOT FIND SYSTEM AT IP: " .. self.args[1])
    elseif self.args[1] == Terminal.ip then
        Terminal:endProg(-1, "YOU CANNOT ATTACK YOUR CURRENT SYSTEM!")
    elseif not Systems[self.args[1]].ports[self.args[2]] then
        Terminal:endProg(-1, "NO PORT WITH NUMBER " .. self.args[2] .. " FOUND AT IP " .. self.args[1])
    elseif Systems[self.args[1]].ports[self.args[2]].status == "closed" then
        Terminal:endProg(-1, "CONNECTION REFUSED.")
    else
        ip = self.args[1]
        port = self.args[2] 
        progressBar = "["
        stepTimer = 0
        step = 0
        CC:startDetection(Terminal.rootIp, ip)
    end
end

function program:update(dt)
    stepTimer = stepTimer + dt
    if stepTimer > STEP_TIME then
        stepTimer = 0
        step = step + 1
        progressBar = progressBar .. "#"
    end

    if not Systems[Terminal.ip] then
        Terminal:endProg()
        Terminal:endProg()
        return
    end

    if step >= STEP_COUNT then
        if math.random(100) > Systems[ip].firewall then
            Terminal.ip = ip
            for key,_ in pairs(Systems[ip].accounts) do
                Terminal.username = key
                break
            end
            Terminal:endProg(0, "SUCCESS.")
        else
            CC:stopDetection(Terminal.rootIp, ip)
            Terminal:endProg(-1, "ATTACK FAILED")
        end
    end
end

function program:draw()
    love.graphics.print("CHANCE OF SUCCESS: " .. (100 - Systems[ip].firewall) .. "%", 16, 16)
    love.graphics.print(progressBar, 16, 40)
    love.graphics.print("] " .. (100 * step / STEP_COUNT) .. "%", 660, 40)
    love.graphics.printf("PRESS ANY KEY TO ABORT", 0, 88, love.graphics.getWidth(), "center")

    local idsIp = CC:isBeingDetected(Terminal.rootIp)
    if idsIp then
        love.graphics.printf("TIME UNTIL DETECTION: " .. string.format("%.1f", Systems[idsIp].ids - CC.ids[idsIp].timer) .. " SECONDS",
        0, 184, love.graphics.getWidth(), "center")
    end
end

function program:keypressed(key)
    CC:stopDetection(Terminal.rootIp, ip)
    Terminal:endProg(-1, "ATTACK ABORTED MANUALLY")
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end
function program:textinput(key) end

return program
