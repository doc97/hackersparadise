CC = {
    ["idsCount"] = 0,
    ["ids"] = { }
}

Env = { }
DefaultEnv = {
    ["reboot"] = { }
}

-- IDS
function CC:isBeingDetected(system)
    for ip, ids in pairs(self.ids) do
        if ids.target == system then return ip end
    end

    return nil
end

function CC:startDetection(attacker, defender)
    if self:hasProcessWithName(defender, "IDS") then
        self.ids[defender] = { ["target"] = attacker, ["timer"] = 0 }
        self.idsCount = self.idsCount + 1
    end
end

function CC:stopDetection(attacker, defender)
    if self:isBeingDetected(attacker, defender) then
        self.ids[defender] = nil
        self.idsCount = self.idsCount - 1
    end
end

-- Processes
function CC:hasProcessWithPID(ip, pid)
    if Systems[ip].processes[tostring(pid)] then return true end
    return false
end

function CC:hasProcessWithName(ip, name)
    for pid,id in pairs(Systems[ip].processes) do
        if id == name then return true end
    end
    return false
end

function CC:startProcess(ip, name, id)
    local pid = id or math.random(100, 999)
    if not self:hasProcessWithPID(ip, tostring(pid)) then
        Systems[ip].processes[tostring(pid)] = name
    end
end

function CC:killProcess(ip, pid)
    if Systems[ip].processes[tostring(pid)] then
        Systems[ip].processes[tostring(pid)] = nil
        if pid == 0 then
            Env.reboot[#Env.reboot + 1] = { ["ip"] = ip, ["timer"] = 20 }
            Systems[ip].online = "false"

            if ip == Terminal.rootIp then Terminal:endProg()
            elseif ip == Terminal.ip then Terminal:runProg("disconnect") end
        end
    end
end

-- Mail
function CC:sendMail(subj, msg, sender)
    local cnt = #Systems[Terminal.rootIp].mail
    Systems[Terminal.rootIp].mail[cnt + 1] = {
        ["source"] = src,
        ["destination"] = dest,
        ["subject"] = subj,
        ["message"] = msg,
        ["sender"] = sender
    }
end

function CC:update(dt)
    -- IDS
    if self.idsCount > 0 then
        for ip, ids in pairs(self.ids) do
            if ids then
                ids.timer = ids.timer + dt
                if not self:hasProcessWithName(ip, "IDS") then
                    self:stopDetection(Terminal.rootIp, ip)
                end

                if Systems[ip].ids > 0 and ids.timer > Systems[ip].ids then
                    print("System at IP " .. ids.target .. " has been obliterated!")
                    Systems[ids.target] = nil
                    self.ids[ip] = nil
                    self.idsCount = self.idsCount - 1
                    love.event.quit()
                end
            end
        end
    end

    -- Rebooting systems
    for i = 1, #Env.reboot, 1 do
        local sys = Env.reboot[i]
        if not getFile(sys.ip, "/", "BOOT/BOOT.CFG") or not getFile(sys.ip, "/", "BOOT/SYSTEM.IMG") then
            Systems[sys.ip].online = "false"
            table.remove(Env.reboot, i)
            i = i - 1
        else
            sys.timer = sys.timer - dt
            if sys.timer < 0 then
                Systems[sys.ip].online = "true"
                Systems[sys.ip].processes["0"] = "ROOT"
                table.remove(Env.reboot, i)
                i = i - 1
            end
        end
    end
end
