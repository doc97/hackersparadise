local program = { args = {} }
local getFileOrDirectory = getFileOrDirectory
local getFilename = getFilename

function program:onEnter()
    if #self.args < 2 then
        Terminal:endProg(-1, "SCP REQUIRES 2 PARAMETERS: <SRC> <DEST>")
    else
        local srcIp, destIp, src, dest

        local srcIp, src = string.match(self.args[1], "(%g+):(%g+)")
        if not srcIp then
            srcIp = Terminal.ip
            src = self.args[1]
        end

        destIp, dest = string.match(self.args[2], "(%g+):(%g+)")
        if not destIp then
            destIp = Terminal.ip
            dest = self.args[2]
        end

        if srcIp == destIp then
            Terminal:endProg(-1, "NO HOST SPECIFIED")
            return
        end

        local srcNode, srcPath = getFileOrDirectory(srcIp, "/", src)
        local destParent, destParentPath = getDirectory(destIp, "/", dest .. "/..")
        local destNode = getFilename("/", dest)
        if destNode == "" then destNode = getFilename("/", table.concat(srcPath)) end

        if not srcNode then
            Terminal:endProg(-1, "NO SUCH FILE OR DIRECTORY")
        elseif not destParent then
            Terminal:endProg(-1, "INVALID DESTINATION")
        elseif not destParent[destNode] then
            local node = {}
            if type(srcNode) == "table" then for k,v in pairs(srcNode) do node[k] = v end
            else node = srcNode end

            destParent[destNode] = node
            Terminal:endProg(0, "COPIED TO " .. table.concat(destParentPath) .. destNode)
        elseif type(destParent[destNode]) ~= "table" then
            Terminal:endProg(-1, "CANNOT OVERWRITE NON-DIRECTORY")
        else
            local node = {}
            if type(srcNode) == "table" then for k,v in pairs(srcNode) do node[k] = v end
            else node = src end

            local cpy = getFilename("/", table.concat(srcPath))
            destParent[destNode][cpy] = node
            Terminal:endProg()
        end
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
