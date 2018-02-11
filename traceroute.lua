local program = { args = {} }

function program:onEnter()
    local ipaddr = Terminal.ip
    local route = { }
    local visited = { }

    repeat
        route[#route + 1] = ipaddr

        if visited[ipaddr] then break end
        visited[ipaddr] = true
        ipaddr = Systems[ipaddr].route
    until ipaddr == ""

    if visited[ipaddr] then
        Terminal:endProg(-1, table.concat(route, "->\n") .. "\nENCOUNTERED A LOOP AT " .. ipaddr)
    else
        Terminal:endProg(0, table.concat(route, "->\n"))
    end
end

-- Unused
function program:onExit() end
function program:onResume() end
function program:onPause() end
function program:update(dt) end
function program:draw() end
function program:keypressed(key) end
function program:textinput(key) end

return program
