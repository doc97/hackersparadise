local program = { args = {} }
local getDirectory = getDirectory
local getFilename = getFilename

function program:onEnter()
    if #self.args < 2 then
        Terminal:endProg(-1, "CP REQUIRES 2 PARAMETERS: <SRC> <DST>")
    else
        local src, srcPath = getDirectory(Terminal.workingDirPath, self.args[1])
        local parent, parentPath = getDirectory(Terminal.workingDirPath, self.args[2] .. "/..")
        local target = getFilename(Terminal.workingDirPath, self.args[2])
        if not src then
            Terminal:endProg(-1, "NO SUCH FILE OR DIRECTORY")
        elseif not parent then
            Terminal:endProg(-1, "INVALID DESTINATION")
        elseif not parent[target] then
            local copy = {}
            for k,v in pairs(src) do copy[k] = v end
            parent[target] = copy
            Terminal:endProg()
        elseif type(parent[target]) ~= "table" then
            Terminal:endProg(-1, "CANNOT OVERWRITE NON-DIRECTORY")
        else
            local copy = {}
            for k,v in pairs(src) do copy[k] = v end

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
