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
local tutorialMsg = {
    { ["msg"] = "WELCOME! YOU HAVE GOT NEW MAIL. TYPE 'MAIL' AND PRESS ENTER TO OPEN THE\nMAIL CLIENT.", ["trigger"] = "mail" },
    { ["msg"] = "TYPE 'SEARCH' AND PRESS ENTER TO FIND THE IP ADDRESS OF THE TEST\nCOMPUTER.", ["trigger"] = "search" },
    { ["msg"] = "FIND OUT MORE INFORMATION WITH 'PROBE <IP ADDRESS>'\n(DO NOT INCLUDE THE '<' AND '>').", ["trigger"] = "probe" },
    { ["msg"] = "USE 'SCAN <IP ADDRESS>' TO SCAN FOR OPEN PORTS.", ["trigger"] = "scan" },
    { ["msg"] = "NOW HACK THE SYSTEM WITH 'HACK <IP ADDRESS> <PORT NUMBER>'.", ["trigger"] = "hack" },
    { ["msg"] = "THE INTRUSION DETECTION SYSTEM IS TRACKING YOU! USE 'PS' TO FIND THE\nPROCESS ID (PID) OF THE PROCESS.", ["trigger"] = "ps" },
    { ["msg"] = "KILL THE PROCESS WITH 'KILL <PID>'.", ["trigger"] = "kill" },
    { ["msg"] = "RESTART THE IDS WITH 'START IDS'.", ["trigger"] = "start" },
    { ["msg"] = "LASTLY, ADD A USER ACCOUNT BY RUNNING 'ADDUSER', YOU CAN LEAVE THE USERNAME\nAND PASSWORD EMPTY.", ["trigger"] = "adduser" },
    { ["msg"] = "CONGRATULATIONS! YOU HAVE SUCCESSFULLY HACKED THE SYSTEM AND CREATED A\nBACKDOOR (THE USER ACCOUNT). RUN 'CONTINUE' TO CONTINUE.", ["trigger"] = "continue" },
    { ["msg"] = "LET'S TAKE A LOOK AT THE FILESYSTEM, USE 'LS' TO LIST THE CONTENTS OF\nTHE CURRENT DIRECTORY.", ["trigger"] = "ls" },
    { ["msg"] = "CHANGE YOUR WORKING DIRECTORY WITH 'CD HOME/DOCUMENTS', NOTE HOW THE\nTEXT IN YOUR PROMPT CHANGES.", ["trigger"] = "cd" },
    { ["msg"] = "READ THE FILE IN THE DOCUMENTS DIRECTORY WITH 'READ <FILENAME>'.", ["trigger"] = "read" },
    { ["msg"] = "EDIT THE FILE WITH 'EDIT <FILENAME>' AND PRESS ESCAPE TO SAVE AND QUIT.", ["trigger"] = "edit" },
    { ["msg"] = "NOW YOU KNOW THE BASICS OF THE FILESYSTEM. RUN 'CONTINUE' TO CONTINUE.", ["trigger"] = "continue" },
    { ["msg"] = "USE 'DISCONNECT' TO DISCONNECT FROM THE SYSTEM AND RETURN TO YOUR\nSTARTING MACHINE, ALSO CALLED THE ROOT MACHINE.", ["trigger"] = "disconnect" },
    { ["msg"] = "RUN 'LISTSYS' TO GET A LIST OF ALL THE SYSTEMS YOU HAVE USED 'PROBE' ON.", ["trigger"] = "listsys" },
    { ["msg"] = "YOU CAN USE 'CONNECT <IP>' TO CONNECT TO ANY SYSTEM THAT YOU HAVE AN\nACCOUNT ON, INCLUDING YOUR ROOT MACHINE.", ["trigger"] = "connect" },
    { ["msg"] = "THAT CONCLUDES THE TUTORIAL, EXPLORE OTHER COMMANDS WITH 'HELP', READ THE\nMANUAL WITH 'MAN' AND CHECK YOUR MAIL. RUN CONTINUE TO FINISH.", ["trigger"] = "continue" }
}
local tutorial = false
local nextTutorial = false
local tutorialListener = ""
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
    ["continue"] = dofile("continue.lua"),
    ["cp"] = dofile("cp.lua"),
    ["deluser"] = dofile("deluser.lua"),
    ["delnote"] = dofile("delnote.lua"),
    ["disconnect"] = dofile("disconnect.lua"),
    ["edit"] = dofile("edit.lua"),
    ["hack"] = dofile("hack.lua"),
    ["kill"] = dofile("kill.lua"),
    ["listusers"] = dofile("listusers.lua"),
    ["listsys"] = dofile("listsys.lua"),
    ["login"] = dofile("login.lua"),
    ["ls"] = dofile("ls.lua"),
    ["mail"] = dofile("mail.lua"),
    ["mkdir"] = dofile("mkdir.lua"),
    ["mv"] = dofile("mv.lua"),
    ["notes"] = dofile("notes.lua"),
    ["passwd"] = dofile("passwd.lua"),
    ["probe"] = dofile("probe.lua"),
    ["ps"] = dofile("ps.lua"),
    ["pwd"] = dofile("pwd.lua"),
    ["read"] = dofile("read.lua"),
    ["root"] = dofile("root.lua"),
    ["rm"] = dofile("rm.lua"),
    ["route"] = dofile("route.lua"),
    ["run"] = dofile("run.lua"),
    ["scan"] = dofile("scan.lua"),
    ["scp"] = dofile("scp.lua"),
    ["search"] = dofile("search.lua"),
    ["start"] = dofile("start.lua"),
    ["traceroute"] = dofile("traceroute.lua"),
    ["unalias"] = dofile("unalias.lua"),
    ["whoami"] = dofile("whoami.lua")
}

function Terminal:newGame()
    Systems = DefaultSystems
    Settings = DefaultSettings
    Env = DefaultEnv
    PlayerInfo = DefaultPlayerInfo

    for ip,sys in pairs(Systems) do
        if not CC:hasProcessWithPID(ip, 0) then CC:startProcess(ip, "ROOT", 0) end
        if sys.firewall > 0 then CC:startProcess(ip, "FIREWALL") end
        if sys.ids > 0 then CC:startProcess(ip, "IDS") end
    end

    -- Send inital mail to user
    CC:sendMail("YOU'RE WELCOME",
    "HI! I SET UP THE TEST COMPUTER PER YOUR REQUEST. I LEFT PORT 21 OPEN,\n" ..
    "YOU SHOULD BE ABLE TO GET IN.\n" ..
    "I'LL TALK TO YOU LATER.\n" ..
    "- R33T", "R33T")

    tutorial = true
    tutorialListener = tutorialMsg[1].trigger
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
    if tutorial and name == tutorialListener then nextTutorial = true end

    if programs[name] then
        for i = 1, args and #args or 0, 1 do
            local arg = args[i]
            for match in string.gmatch(arg, "%b{}") do
                local alias = Settings.aliases[string.sub(match, 2, -2)]
                if alias then arg = string.gsub(arg, match, alias) end
            end
            args[i] = arg
        end

        if #progStack > 0 then Stack.peek(progStack):onPause() end
        Stack.push(progStack, programs[name])
        Stack.peek(progStack).args = args
        Stack.peek(progStack):onEnter()

        return true
    else
        return false
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

    if tutorial and nextTutorial and (retCode == nil or retCode == 0) then
        table.remove(tutorialMsg, 1)
        nextTutorial = false
        if #tutorialMsg > 0 then
            tutorialListener = tutorialMsg[1].trigger
        else
            tutorial = false
            Settings.showNotes = "true"
            CC:sendMail("JOIN CTF",
                "HEY, I SAW THAT YOU GOT INTO THE TEST COMPUTER, GOOD. I FOUND A CTF (CAPTURE THE\n" ..
                "FLAG) CHALLENGE, IF YOU WANT TO JOIN: 192.168.1.3\n" ..
                "- R33T", "R33T")
        end
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

function Terminal:drawTutorialMessage()
    if tutorial then
        local color = { }
        for i = 1, #Systems[Terminal.ip].color, 1 do color[i] = Systems[Terminal.ip].color[i] * 0.5 end
        love.graphics.setColor(color)
        love.graphics.setFont(Fonts["bold-16"])
        love.graphics.rectangle("fill", 30, love.graphics.getHeight() - 138, love.graphics.getWidth() - 64, 64)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(tutorialMsg[1].msg, 38, love.graphics.getHeight() - 130)
        love.graphics.setColor(Systems[Terminal.ip].color)
    end
end

function Terminal:keypressed(key)
    if #progStack > 0 then Stack.peek(progStack):keypressed(key) end
end

function Terminal:textinput(key)
    if #progStack > 0 then Stack.peek(progStack):textinput(key) end
end
