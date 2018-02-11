require "fsutils"
require "stack"

BLINK_TIME = 0.5

Terminal = {
    user = "ADMIN",
    username = "NULL",
    ip = "192.168.1.1",
    rootIp = "192.168.1.1",
    rootUsername = "ROOT",
    workingDir = {},
    workingDirPath = "/",
    returnCode = 0,
    returnStr = ""
}

local progStack = Stack.new()
local programs = {
    ["adduser"] = dofile("adduser.lua"),
    ["addnote"] = dofile("addnote.lua"),
    ["alias"] = dofile("alias.lua"),
    ["boot"] = dofile("boot.lua"),
    ["cd"] = dofile("cd.lua"),
    ["chown"] = dofile("chown.lua"),
    ["color"] = dofile("color.lua"),
    ["connect"] = dofile("connect.lua"),
    ["cp"] = dofile("cp.lua"),
    ["deluser"] = dofile("deluser.lua"),
    ["delnote"] = dofile("delnote.lua"),
    ["disconnect"] = dofile("disconnect.lua"),
    ["edit"] = dofile("edit.lua"),
    ["hack"] = dofile("hack.lua"),
    ["kill"] = dofile("kill.lua"),
    ["listusers"] = dofile("listusers.lua"),
    ["login"] = dofile("login.lua"),
    ["ls"] = dofile("ls.lua"),
    ["mail"] = dofile("mail.lua"),
    ["mkdir"] = dofile("mkdir.lua"),
    ["mv"] = dofile("mv.lua"),
    ["notes"] = dofile("notes.lua"),
    ["passwd"] = dofile("passwd.lua"),
    ["probe"] = dofile("probe.lua"),
    ["ps"] = dofile("ps.lua"),
    ["read"] = dofile("read.lua"),
    ["root"] = dofile("root.lua"),
    ["rm"] = dofile("rm.lua"),
    ["route"] = dofile("route.lua"),
    ["run"] = dofile("run.lua"),
    ["scan"] = dofile("scan.lua"),
    ["scp"] = dofile("scp.lua"),
    ["search"] = dofile("search.lua"),
    ["start"] = dofile("start.lua"),
    ["traceroute"] = dofile("traceroute.lua")
}

function Terminal:newGame()
    Systems = DefaultSystems
    Settings = DefaultSettings
    Env = DefaultEnv

    for ip,sys in pairs(Systems) do
        if not CC:hasProcessWithPID(ip, 0) then CC:startProcess(ip, "ROOT", 0) end
        if sys.firewall > 0 then CC:startProcess(ip, "FIREWALL") end
        if sys.ids > 0 then CC:startProcess(ip, "IDS") end
    end

    -- Send inital mail to user
    CC:sendMail("WELCOME", "THIS GAME IS AWESOME", "GAMEMASTER")
    CC:sendMail("FIRST THINGS FIRST", "ALSO... YOU ARE CUTE :>", "GAMEMASTER")
end

function Terminal:continueGame()
    local err1, err2, err3
    Systems, err1 = table.load("systems-save.lua")
    Settings, err2 = table.load("settings-save.lua")
    Env, err3 = table.load("env-save.lua")

    if err1 or err2 or err3 then
        self:newGame()
    else
        for ip,sys in pairs(Systems) do
            if not getFile(ip, "/", "BOOT/BOOT.CFG") or not getFile(ip, "/", "BOOT/SYSTEM.IMG") then sys.online = "false" end
        end
    end
end

function Terminal:start()
    Terminal:runProg("boot")
end

function Terminal:runProg(name, args)
    if programs[name] then
        if #progStack > 0 then Stack.peek(progStack):onPause() end
        Stack.push(progStack, programs[name])
        Stack.peek(progStack).args = args
        Stack.peek(progStack):onEnter()
    end
end

function Terminal:endProg(retCode, retStr)
    if #progStack > 1 then
        Stack.peek(progStack):onExit()
        Stack.pop(progStack)
        self.returnCode = retCode or 0
        self.returnStr = retStr or ""
        if #progStack > 0 then Stack.peek(progStack):onResume() end
    end
end

function Terminal:update(dt)
    if #progStack > 0 then Stack.peek(progStack):update(dt) end
end

function Terminal:draw()
    if #progStack > 0 then Stack.peek(progStack):draw() end
    love.graphics.printf("FPS: " .. love.timer.getFPS(), -16, 16, love.graphics.getWidth(), "right")
end

function Terminal:drawBanner()
    love.graphics.setColor(Systems[Terminal.ip].color)
    love.graphics.printf("-== PROPERTY OF " .. Systems[Terminal.ip].owner .. " ==-", 0, 16, love.graphics.getWidth(), "center")
end

function Terminal:keypressed(key)
    if #progStack > 0 then Stack.peek(progStack):keypressed(key) end
end

function Terminal:textinput(key)
    if #progStack > 0 then Stack.peek(progStack):textinput(key) end
end
