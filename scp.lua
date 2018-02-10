local program = { args = {} }
local getFileOrDirectory = getFileOrDirectory
local getFilename = getFilename

function program:onEnter()
    if Terminal.ip == Terminal.rootIp then
        Terminal:endProg(-1, "CANNOT TRANSFER FILES FROM AND TO THE ROOT SYSTEM")
    elseif #self.args < 2 then
        Terminal:endProg(-1, "SCP REQUIRES 2 PARAMETERS: <SRC> <DEST>")
    else
        local src, srcPath = getFileOrDirectory(Terminal.ip, Terminal.workingDirPath, self.args[1])
        local parent, parentPath = getFileOrDirectory(Terminal.rootIp, "/", self.args[2] .. "/..")
        local target = getFilename("/", self.args[2])

        if not src then
            Terminal:endProg(-1, "NO SUCH FILE OR DIRECTORY")
        elseif not parent then
            Terminal:endProg(-1, "INVALID DESTINATION")
        elseif not parent[target] then
            local copy = {}
            if type(src) == "table" then
                for k,v in pairs(src) do copy[k] = v end
                parent[target] = copy
            else
                parent[target] = src
            end
            Terminal:endProg()
        elseif type(parent[target]) ~= "table" then
            Terminal:endProg(-1, "CANNOT OVERWRITE NON-DIRECTORY")
        else
            local copy = {}
            if type(src) == "table" then
                for k,v in pairs(src) do copy[k] = v end
            else
                copy = src
            end

            local cpy = getFilename("/", table.concat(srcPath))
            parent[target][cpy] = copy
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
